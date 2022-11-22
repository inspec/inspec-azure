require 'azure_generic_resource'

class AzureMySqlDatabaseConfiguration < AzureGenericResource
  name 'azure_mysql_database_configuration'
  desc 'Verifies settings for an Azure MySQL Database Configuration.'
  example <<-EXAMPLE
    describe azure_mysql_database_configuration(resource_group: 'rg-1', server_name: 'mysql-server-1', name: 'configuration-name') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.DBforMySQL/servers', opts)
    opts[:required_parameters] = %i(server_name)
    opts[:resource_path] = [opts[:server_name], 'configurations'].join('/')
    opts[:resource_identifiers] = %i(configuration_name)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureMySqlDatabaseConfiguration)
  end
end
