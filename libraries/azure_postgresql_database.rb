require 'azure_generic_resource'

class AzurePostgreSQLDatabase < AzureGenericResource
  name 'azure_postgresql_database'
  desc 'Verifies settings for an Azure PostgreSQL Database'
  example <<-EXAMPLE
    describe azure_postgresql_database(resource_group: 'rg-1', server_name: 'psql-server-1' name: 'customer-db') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:required_parameters] = %i(server_name)
    opts[:resource_path] = [opts[:server_name], 'databases'].join('/')
    opts[:resource_provider] = specific_resource_constraint('Microsoft.DBforPostgreSQL/servers', opts)
    opts[:resource_identifiers] = %i(database_name)

    # static_resource parameter must be true for setting the scene in the backend.
    super(opts, true)
  end

  def to_s
    super(AzurePostgreSQLDatabase)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermPostgreSQLDatabase < AzurePostgreSQLDatabase
  name 'azurerm_postgresql_database'
  desc 'Verifies settings for an Azure PostgreSQL Database'
  example <<-EXAMPLE
    describe azurerm_postgresql_database(resource_group: 'rg-1', server_name: 'psql-server-1' database_name: 'customer-db') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzurePostgreSQLDatabase.name)
    super
  end
end
