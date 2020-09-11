require 'azure_generic_resource'

class AzurePostgreSQLServer < AzureGenericResource
  name 'azure_postgresql_server'
  desc 'Verifies settings for an Azure PostgreSQL Server'
  example <<-EXAMPLE
    describe azure_postgresql_server(resource_group: 'rg-1', server_name: 'psql-srv') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.DBforPostgreSQL/servers', opts)
    opts[:resource_identifiers] = %i(server_name)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Convenient access e.g. configurations.{config_name}.properties.value.eql?("on")
    create_configurations
  end

  def to_s
    super(AzurePostgreSQLServer)
  end

  # Resource specific methods can be created.
  # `return unless exists?` is necessary to prevent any unforeseen Ruby error.
  # Following methods are created to provide the same functionality with the current resource pack >>>>
  # @see https://github.com/inspec/inspec-azure

  private

  def create_configurations
    return unless exists?
    resource_uri = id + '/configurations'
    query = {
      resource_uri: resource_uri,
    }
    confs = get_resource(query)[:value].map { |c| [c[:name], c] }.to_h
    create_resource_methods({ configurations: confs })
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermPostgreSQLServer < AzurePostgreSQLServer
  name 'azurerm_postgresql_server'
  desc 'Verifies settings for an Azure PostgreSQL Server'
  example <<-EXAMPLE
    describe azurerm_postgresql_server(resource_group: 'rg-1', server_name: 'psql-srv') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzurePostgreSQLServer.name)
    super
  end
end
