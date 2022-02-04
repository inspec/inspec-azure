require 'azure_generic_resources'

class AzureMySqlDatabases < AzureGenericResources
  name 'azure_mysql_databases'
  desc 'Verifies settings for a collection of Azure MySQL Databases on a MySQL Server'
  example <<-EXAMPLE
    describe azure_mysql_databases(resource_group: 'my-rg', server_name: 'server-1') do
        it            { should exist }
        its('names')  { should_not be_empty }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.DBforMySQL/servers', opts)
    opts[:required_parameters] = %i(resource_group server_name)
    # Unless provided here, a generic display name will be created in the backend.
    opts[:display_name] = "Databases on #{opts[:server_name]} MySQL Server"
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
      { column: :ids, field: :id },
      { column: :properties, field: :properties },
      { column: :types, field: :type },
      { column: :tags, field: :tags },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureMySqlDatabases)
  end
end
