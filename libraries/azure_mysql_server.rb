require 'azure_generic_resource'

class AzureMysqlServer < AzureGenericResource
  name 'azure_mysql_server'
  desc 'Verifies settings for an Azure My SQL Server'
  example <<-EXAMPLE
    describe azurerm_mysql_server(resource_group: 'example', server_name: 'vm-name') do
      it { should have_monitoring_agent_installed }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format for the resource:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #   Microsoft.DBforMySQL/servers/{serverName}?api-version=2017-12-01
    #
    # The dynamic part that has to be created in this resource:
    #   Microsoft.DBforMySQL/servers/{serverName}?api-version=2017-12-01
    #
    # Parameters acquired from environment variables:
    #   - {subscriptionId} => Required parameter. It will be acquired by the backend from environment variables.
    #
    # For parameters applicable to all resources, see project's README.
    #
    # User supplied parameters:
    #   - resource_group => Required parameter unless `resource_id` is provided. {resourceGroupName}
    #   - name => Required parameter unless `resource_id` is provided. Name of the resource to be tested.
    #   - resource_id => Optional parameter. If exists, other resource related parameters must not be provided.
    #     In the following format:
    #       /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #       Microsoft.DBforMySQL/servers/{serverName}
    #   - api_version => Optional parameter. The latest version will be used unless provided.
    #
    #   **`resource_group`, (resource) `name` and `resource_id`  will be validated in the backend appropriately.
    #     We don't have to do anything here.
    #
    # Following resource parameters have to be defined/created here.
    #   resource_provider => Microsoft.Network/virtualNetworks
    #     The `specific_resource_constraint` method will validate the user input
    #       not to accept a different `resource_provider`.
    #
    opts[:resource_provider] = specific_resource_constraint('Microsoft.DBforMySQL/servers', opts)
    opts[:resource_identifiers] = %i(server_name)

    # At this point there is enough data to construct the resource id.
    super(opts, true)
  end

  def to_s
    super(AzureMysqlServer)
  end

  # Resource specific methods can be created.
  # `return unless exists?` is necessary to prevent any unforeseen Ruby error.
  # Following methods are created to provide the same functionality with the current resource pack >>>>
  # @see https://github.com/inspec/inspec-azure

  # Azure Rest API endpoint for MySql firewall rules
  #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
  #   Microsoft.DBforMySQL/servers/{serverName}/firewallRules?api-version=2017-12-01
  #
  # #getresource method
  #
  def firewall_rules
    return unless exists?
    resource_uri = id + '/firewallRules'
    api_query_for_firewall = {
      resource_uri: resource_uri,
    }
    @firewall_rules ||= get_resource(api_query_for_firewall)[:value]
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermMysqlServer < AzureMysqlServer
  name 'azurerm_mysql_server'
  desc 'Verifies settings for an Azure My SQL Server'
  example <<-EXAMPLE
    describe azurerm_mysql_server(resource_group: 'example', server_name: 'vm-name') do
      it { should have_monitoring_agent_installed }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureMysqlServer.name)
    super
  end
end
