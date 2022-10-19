require 'azure_generic_resources'

class AzureMysqlServers < AzureGenericResources
  name 'azure_mysql_servers'
  desc 'Verifies settings for a collection of Azure MySQL Servers.'
  example <<-EXAMPLE
    describe azurerm_mysql_servers do
      it { should exist }
      its('names') { should include 'MYSQL_SERVER_NAME' }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format listing the all resources for a given subscription:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/providers/
    #   Microsoft.DBforMySQL/servers?api-version=2017-12-01
    #
    # or in a resource group only
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #   Microsoft.DBforMySQL/servers?api-version=2017-12-01
    #
    # The dynamic part that has to be created for this resource:
    #   Microsoft.DBforMySQL/servers?api-version=2017-12-01
    #
    # Parameters acquired from environment variables:
    #   - {subscriptionId} => Required parameter. It will be acquired by the backend from environment variables.
    #
    # For parameters applicable to all resources, see project's README.
    #
    # User supplied parameters:
    #   - resource_group => Optional parameter.
    #   - api_version => Optional parameter. The latest version will be used unless provided.
    #
    #   **`resource_group`  will be used in the backend appropriately.
    #     We don't have to do anything here.
    #
    # Following resource parameters have to be defined/created here.
    #   resource_provider => Microsoft.DBforMySQL/servers
    #     The `specific_resource_constraint` method will validate the user input
    #       not to accept a different `resource_provider`.
    #
    opts[:resource_provider] = specific_resource_constraint('Microsoft.DBforMySQL/servers', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    # @see https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md
    table_schema = [
      { column: :names, field: :name },
      { column: :skus, field: :sku },
      { column: :ids, field: :id },
      { column: :tags, field: :tags },
      { column: :types, field: :type },
      { column: :locations, field: :location },
      { column: :properties, field: :properties },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureMysqlServers)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermMysqlServers < AzureMysqlServers
  name 'azurerm_mysql_servers'
  desc 'Verifies settings for a collection of Azure MySQL Servers'
  example <<-EXAMPLE
    describe azurerm_mysql_servers do
        its('names')  { should include 'my-sql-server' }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureMysqlServers.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2017-12-01'
    super
  end
end
