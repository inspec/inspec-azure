require "inifile"
require "kitchen/logging"
autoload :MsRest, "ms_rest"

module Kitchen
  module Driver
    #
    # AzureCredentials
    #
    class AzureCredentials
      include Kitchen::Logging

      CONFIG_PATH = "#{ENV["HOME"]}/.azure/credentials".freeze

      #
      # @return [String]
      #
      attr_reader :subscription_id

      #
      # @return [String]
      #
      attr_reader :environment

      #
      # Creates and initializes a new instance of the Credentials class.
      #
      def initialize(subscription_id:, environment: "Azure")
        @subscription_id = subscription_id
        @environment = environment
      end

      #
      # Retrieves an object containing options and credentials
      #
      # @return [Object] Object that can be supplied along with all Azure client requests.
      #
      def azure_options
        options = { tenant_id: tenant_id!,
                    subscription_id: subscription_id,
                    credentials: ::MsRest::TokenCredentials.new(token_provider),
                    active_directory_settings: ad_settings,
                    base_url: endpoint_settings.resource_manager_endpoint_url }
        options[:client_id] = client_id if client_id
        options[:client_secret] = client_secret if client_secret
        options
      end

      private

      def logger
        Kitchen.logger
      end

      def config_path
        @config_path ||= File.expand_path(ENV["AZURE_CONFIG_FILE"] || CONFIG_PATH)
      end

      def credentials
        @credentials ||= if File.file?(config_path)
                           IniFile.load(config_path)
                         else
                           debug "#{config_path} was not found or not accessible."
                           {}
                         end
      end

      def credentials_property(property)
        credentials[subscription_id]&.[](property)
      end

      def tenant_id!
        tenant_id || warn("(#{config_path}) does not contain tenant_id neither is the AZURE_TENANT_ID environment variable set.")
      end

      def tenant_id
        ENV["AZURE_TENANT_ID"] || credentials_property("tenant_id")
      end

      def client_id
        ENV["AZURE_CLIENT_ID"] || credentials_property("client_id")
      end

      def client_secret
        ENV["AZURE_CLIENT_SECRET"] || credentials_property("client_secret")
      end

      # Retrieve a token based upon the preferred authentication method.
      #
      # @return [::MsRest::TokenProvider] A new token provider object.
      def token_provider
        # Login with a credentials file or setting the environment variables
        #
        # Typically used with a service principal.
        #
        # SPN with client_id, client_secret and tenant_id
        if client_id && client_secret && tenant_id
          ::MsRestAzure::ApplicationTokenProvider.new(tenant_id, client_id, client_secret, ad_settings)
        # Login with a Managed Service Identity.
        #
        # Typically used with a Managed Service Identity when you have a particular object registered in a tenant.
        #
        # MSI with client_id and tenant_id (aka User Assigned Identity).
        elsif client_id && tenant_id
          ::MsRestAzure::MSITokenProvider.new(50342, ad_settings, { client_id: client_id })
        # Default approach to inheriting existing object permissions (application or device this code is running on).
        #
        # Typically used when you want to inherit the permissions of the system you're running on that are in a tenant.
        #
        # MSI with just tenant_id (aka System Assigned Identity).
        elsif tenant_id
          ::MsRestAzure::MSITokenProvider.new(50342, ad_settings)
        # Login using the Azure CLI
        #
        # Typically used when you want to rely upon `az login` as your preferred authentication method.
        else
          warn("Using tenant id set through `az login`.")
          ::MsRestAzure::AzureCliTokenProvider.new(ad_settings)
        end
      end

      #
      # Retrieves a [MsRestAzure::ActiveDirectoryServiceSettings] object representing the AD settings for the given cloud.
      #
      # @return [MsRestAzure::ActiveDirectoryServiceSettings] Settings to be used for subsequent requests
      #
      def ad_settings
        case environment.downcase
        when "azureusgovernment"
          ::MsRestAzure::ActiveDirectoryServiceSettings.get_azure_us_government_settings
        when "azurechina"
          ::MsRestAzure::ActiveDirectoryServiceSettings.get_azure_china_settings
        when "azuregermancloud"
          ::MsRestAzure::ActiveDirectoryServiceSettings.get_azure_german_settings
        when "azure"
          ::MsRestAzure::ActiveDirectoryServiceSettings.get_azure_settings
        end
      end

      #
      # Retrieves a [MsRestAzure::AzureEnvironment] object representing endpoint settings for the given cloud.
      #
      # @return [MsRestAzure::AzureEnvironment] Settings to be used for subsequent requests
      #
      def endpoint_settings
        case environment.downcase
        when "azureusgovernment"
          ::MsRestAzure::AzureEnvironments::AzureUSGovernment
        when "azurechina"
          ::MsRestAzure::AzureEnvironments::AzureChinaCloud
        when "azuregermancloud"
          ::MsRestAzure::AzureEnvironments::AzureGermanCloud
        when "azure"
          ::MsRestAzure::AzureEnvironments::AzureCloud
        end
      end
    end
  end
end
