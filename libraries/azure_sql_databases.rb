require 'azure_generic_resources'

class AzureSqlDatabases < AzureGenericResources
  name 'azure_sql_databases'
  desc 'Verifies settings for a collection of Azure SQL Databases on a SQL Server.'
  example <<-EXAMPLE
    describe azure_sql_databases(resource_group: 'RESOURCE_GROUP_NAME', server_name: 'SERVER_NAME') do
      it { should exist }
      its('names') { should_not be_empty }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Sql/servers', opts)
    opts[:required_parameters] = %i(resource_group server_name)
    opts[:display_name] = "Databases on #{opts[:server_name]} SQL Server"
    opts[:resource_path] = [opts[:server_name], 'databases'].join('/')

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
      { column: :kinds, field: :kind },
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
    super(AzureSqlDatabases)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermSqlDatabases < AzureSqlDatabases
  name 'azurerm_sql_databases'
  desc 'Verifies settings for a collection of Azure SQL Databases on a SQL Server'
  example <<-EXAMPLE
    describe azurerm_sql_databases(resource_group: 'my-rg', server_name: 'server-1') do
        it            { should exist }
        its('names')  { should_not be_empty }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureSqlDatabases.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2017-10-01-preview'
    super
  end
end
