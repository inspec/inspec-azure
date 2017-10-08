require 'ms_rest_azure'
require 'azure_mgmt_resources'
require 'azure_mgmt_compute'
require 'azure_mgmt_network'
require 'inifile'

# Class to manage the connection to Azure to retrieve the information required about the resources
#
# @author Russell Seymour
#
# @attr_reader [String] subscription_id ID of the subscription in which resources are to be tested
class AzureConnection
  attr_reader :subscription_id

  # Constructor which reads in the credentials file
  #
  # @author Russell Seymour
  def initialize
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
      warn format('%s was not found or not accessible', azure_creds_file)
    end
  end

  # Connect to Azure using the specified credentials
  #
  # @author Russell Seymour
  def connection
    # If a connection already exists then return it
    return @conn if defined?(@conn)

    creds = spn

    # Create a new connection
    token_provider = MsRestAzure::ApplicationTokenProvider.new(creds[:tenant_id], creds[:client_id], creds[:client_secret])
    @conn = MsRest::TokenCredentials.new(token_provider)
  end

  # Method to retrieve the SPN credentials
  # This is also used by the Rakefile to get the necessary creds to run the tests on the environment
  # that has been created
  #
  # @author Russell Seymour
  def spn
    @subscription_id = azure_subscription_id

    # Check that the credential exists
    raise format('The specified Azure Subscription cannot be found in your credentials: %s', subscription_id) unless @credentials.sections.include?(subscription_id)

    # Determine the client_id, tenant_id and the client_secret
    tenant_id = ENV['AZURE_TENANT_ID'] || @credentials[subscription_id]['tenant_id']
    client_id = ENV['AZURE_CLIENT_ID'] || @credentials[subscription_id]['client_id']
    client_secret = ENV['AZURE_CLIENT_SECRET'] || @credentials[subscription_id]['client_secret']

    # Return hash of the SPN information
    { subscription_id: subscription_id, client_id: client_id, client_secret: client_secret, tenant_id: tenant_id }
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

# Helper class to configure and give access to the various management components of Azure
# Also provides shortcuts for certain components, such as returing the VM object and performing
# all the checks that need to be done before retrieving the VM
#
# @author Russell Seymour
# @attr_reader [MsRest::TokenCredentials] azure Azure connection credentials
# @attr_reader [ComputeManagement] compute_mgmt Compute object for retrieving details about VMs
# @attr_reader [ResourceManagement] resource_mgmt Resource object for accessing specific resources and resoure groups
# @attr_reader [NetworkManagement] network_mgmt Network object for retrieving all information about Network cards and IP configurations
class Helpers
  attr_reader :azure, :compute_mgmt, :resource_mgmt, :network_mgmt

  # Constructor to configure the various objects that are required for Inspec testing
  #
  # @author Russell Seymour
  def initialize
    # Azure connection
    @azure = AzureConnection.new

    # Create the necessary clients
    @compute_mgmt = ComputeManagement.new(azure)
    @resource_mgmt = ResourceManagement.new(azure)
    @network_mgmt = NetworkManagement.new(azure)
  end

  # Retrieve the named virtual machine from Azure
  #
  # This is specified here as it combines two different resource types, Compute and Resource Groups
  #
  # @author Russell Seymour
  #
  # @return [] VM object
  #
  def get_vm(name, rg_name)
    # Ensure that the resource group exists
    unless resource_mgmt.client.resource_groups.check_existence(rg_name)
      raise "The Resource group cannot be found: #{rg_name}"
    end

    # Return if no name has been specified
    return if name.nil?

    # get a vm from the named resource group
    begin
      compute_mgmt.client.virtual_machines.get(rg_name, name)
    # TODO: we should avoid doing a general rescue, will be covered with InSpec 2.0 integration
    rescue => e
      e.error_message
    end
  end
end

# Class to return a NetworkManagement client for use with NICs and Public IP Addresses
#
# @author Russell Seymour
# @attr_reader [Azure::ARM::Network::NetworkManagementClient] client Azure Network Management cient
class ResourceManagement
  attr_reader :client

  # Constructor for the class.  Creates the new Network Management client object
  #
  # @author Russell Seymour
  #
  # @param [MsRest::TokenCredentials] azure Connection object for Azure
  def initialize(azure)
    @client = Azure::ARM::Resources::ResourceManagementClient.new(azure.connection)
    client.subscription_id = azure.subscription_id
  end

  # Determine if the specified resource group exists in the subscription_id
  #
  # @author Russell Seymour
  #
  # @param [String] name Name of the resource group
  #
  # @return [Boolean] Whether the resource group exists or not
  def exists(name)
    client.resource_groups.check_existence(name)
  end

  # Retrieve the named resource group if it exists
  #
  # @author Russell Seymour
  #
  # @param [String] name Name of the resource group
  #
  # @return [Azure::ARM::Resources::Models::ResourceGroup] Object containing information about the resource group
  def get_resource_group(name)
    client.resource_groups.get(name) if exists(name)
  end

  # Get all of the resources that are contained within the resource group if it exists
  #
  # @author Russell Seymour
  #
  # @param [String] name Name of the resource group
  #
  # @return [Azure::ARM::Resources::Models::ResourceListResult] Object containing array of all the resources
  def get_resources(name)
    client.resources.list_by_resource_group_as_lazy(name) if exists(name)
  end
end

# Class to return a ComputeManagement client to get information about VMs
#
# @author Russell Seymour
#
# @attr_reader [Azure::ARM::Compute::ComputeManagementClient] client ComputeManagement client object
class ComputeManagement
  attr_reader :client

  # Constructor for the class.  Creates the new Network Management client object
  #
  # @author Russell Seymour
  #
  # @param [MsRest::TokenCredentials] azure Connection object for Azure
  def initialize(azure)
    @client = Azure::ARM::Compute::ComputeManagementClient.new(azure.connection)
    client.subscription_id = azure.subscription_id
  end
end

# Class to return a NetworkManagement client for use with NICs and Public IP Addresses
#
# @author Russell Seymour
# @attr_reader [Azure::ARM::Network::NetworkManagementClient] client Azure Network Management cient
class NetworkManagement
  attr_reader :client

  # Constructor for the class.  Creates the new Network Management client object
  #
  # @author Russell Seymour
  #
  # @param [MsRest::TokenCredentials] azure Connection object for Azure
  def initialize(azure)
    @client = Azure::ARM::Network::NetworkManagementClient.new(azure.connection)
    client.subscription_id = azure.subscription_id
  end
end
