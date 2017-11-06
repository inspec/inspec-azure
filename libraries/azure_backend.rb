# frozen_string_literal: true

require 'ms_rest_azure'
require 'azure_mgmt_resources'
require 'inifile'

# Class to manage the connection to Azure to retrieve the information required about the resources
#
# @author Russell Seymour
#
# @attr_reader [String] subscription_id ID of the subscription in which resources are to be tested
class AzureConnection
  attr_reader :subscription_id, :apis

  # Constructor which reads in the credentials file
  #
  # @author Russell Seymour
  def initialize
    # Ensure that the apis is a hash table
    @apis = {}

    # If an INSPEC_AZURE_CREDS environment has been specified set the
    # the credentials file to that, otherwise set the one in home
    azure_creds_file = ENV['AZURE_CREDS_FILE']
    if azure_creds_file.nil?

      # The environment file has not be set, so default to one in the home directory
      azure_creds_file = File.join(Dir.home, '.azure', 'credentials')
    end

    # Check to see if the credentials file exists
    if File.file?(azure_creds_file)
      @credentials = IniFile.load(File.expand_path(azure_creds_file))
    else
      @credentials = nil
      warn format('%s was not found or not accessible', azure_creds_file)
    end
  end

  # Connect to Azure using the specified credentials
  #
  # @author Russell Seymour
  def client
    # If a connection already exists then return it
    return @client if defined?(@client)

    creds = spn

    # Create a new connection
    token_provider = MsRestAzure::ApplicationTokenProvider.new(creds[:tenant_id], creds[:client_id], creds[:client_secret])
    token_creds = MsRest::TokenCredentials.new(token_provider)

    # Create the options hash
    options = {
      credentials: token_creds,
      subscription_id: azure_subscription_id,
      tenant_id: creds[:tenant_id],
      client_id: creds[:client_id],
      client_secret: creds[:client_secret],
    }

    @client = Azure::Resources::Profiles::Latest::Mgmt::Client.new(options)
  end

  # Method to retrieve the SPN credentials
  # This is also used by the Rakefile to get the necessary creds to run the tests on the environment
  # that has been created
  #
  # @author Russell Seymour
  def spn
    @subscription_id = azure_subscription_id

    # Check that the credential exists
    unless @credentials.nil?
      raise format('The specified Azure Subscription cannot be found in your credentials: %s', subscription_id) unless @credentials.sections.include?(subscription_id)
    end

    # Determine the client_id, tenant_id and the client_secret
    tenant_id = ENV['AZURE_TENANT_ID'] || @credentials[subscription_id]['tenant_id']
    client_id = ENV['AZURE_CLIENT_ID'] || @credentials[subscription_id]['client_id']
    client_secret = ENV['AZURE_CLIENT_SECRET'] || @credentials[subscription_id]['client_secret']

    # Return hash of the SPN information
    { subscription_id: subscription_id, client_id: client_id, client_secret: client_secret, tenant_id: tenant_id }
  end

  # Returns the api version for the specified resource type
  #
  # If an api version has been specified in the options then the apis version table is updated
  # with that value and it is returned
  #
  # However if it is not specified, or multiple types are being interrogated then this method
  # will interrogate Azure for each of the types versions and pick the latest one. This is added
  # to the apis table so that it can be retrieved quickly again of another one of those resources
  # is encountered again in the resource collection.
  #
  # @param string resource_type The resource type for which the API is required
  # @param hash options Options have that have been passed to the resource during the test.
  # @option opts [String] :group_name Resource group name
  # @option opts [String] :type Azure resource type
  # @option opts [String] :name Name of specific resource to look for
  # @option opts [String] :apiversion If looking for a specific item or type specify the api version to use
  #
  # @return string API Version of the specified resource type
  def get_api_version(resource_type, options)
    # if an api version has been set in the options, add to the apis hashtable with
    # the resource type
    if options[:apiversion]
      apis[resource_type] = options[:apiversion]
    else
      # only attempt to get the api version from Azure if the resource type
      # is not present in the apis hashtable
      unless apis.key?(resource_type)

        # determine the namespace for the resource type
        namespace, type = resource_type.split(%r{/})

        provider = client.providers.get(namespace)

        # get the latest API version for the type
        # assuming that this is the first one in the list
        api_versions = (provider.resource_types.find { |v| v.resource_type == type }).api_versions
        apis[resource_type] = api_versions[0]

      end
    end

    # return the api version for the type
    apis[resource_type]
  end

  private

  # Return the subscrtiption ID to use
  #
  # @author Russell Seymour
  def azure_subscription_id
    # If a subscription has been specified as an environment variable use that
    # If an index has been specified with AZURE_SUBSCRIPTION_INDEX attempt to use that value
    # Otherwise use the first entry in the file
    if !ENV['AZURE_SUBSCRIPTION_ID'].nil?
      id = ENV['AZURE_SUBSCRIPTION_ID']
    elsif !ENV['AZURE_SUBSCRIPTION_NUMBER'].nil?

      subscription_number = ENV['AZURE_SUBSCRIPTION_NUMBER'].to_i
      subscription_index = subscription_number - 1

      # Check that the specified index is not greater than the number of subscriptions
      if subscription_number > @credentials.sections.length
        raise format('Your credentials file only contains %s subscriptions.  You specified number %s.', @credentials.sections.length, subscription_number)
      end

      id = @credentials.sections[subscription_index]
    else
      id = @credentials.sections[0]
    end

    # Return the ID to the calling function
    id
  end
end
