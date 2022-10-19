require 'azure_generic_resources'

class AzureMariaDBServers < AzureGenericResources
  name 'azure_mariadb_servers'
  desc 'Verifies settings for a collection of Azure MariaDB Servers.'
  example <<-EXAMPLE
    describe azure_mariadb_servers do
      its('names') { should include 'MARIADB_SERVER_NAME' }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.DBforMariaDB/servers', opts)

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
    super(AzureMariaDBServers)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermMariaDBServers < AzureMariaDBServers
  name 'azurerm_mariadb_servers'
  desc 'Verifies settings for a collection of Azure MariaDB Servers'
  example <<-EXAMPLE
    describe azurerm_mariadb_servers do
        its('names')  { should include 'mariadb-server' }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureMariaDBServers.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2018-06-01-preview'
    super
  end
end
