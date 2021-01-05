require 'azure_generic_resource'

class AzureMariaDBServer < AzureGenericResource
  name 'azure_mariadb_server'
  desc 'Verifies settings for an Azure MariaDB Server'
  example <<-EXAMPLE
    describe azure_mariadb_server(resource_group: 'rg-1', name: 'my-server-name') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.DBforMariaDB/servers', opts)
    opts[:resource_identifiers] = %i(server_name)
    opts[:allowed_parameters] = %i(firewall_rules_api_version)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    @opts[:firewall_rules_api_version] ||= 'latest'
  end

  def to_s
    super(AzureMariaDBServer)
  end

  # Resource specific methods can be created.
  # `return unless exists?` is necessary to prevent any unforeseen Ruby error.
  # Following methods are created to provide the same functionality with the current resource pack >>>>
  # @see https://github.com/inspec/inspec-azure

  # @see AzureKeyVault#diagnostic_settings for how to use #additional_resource_properties method.
  #
  def firewall_rules
    return unless exists?
    additional_resource_properties(
      {
        property_name: 'firewall_rules',
        property_endpoint: "#{id}/firewallRules",
        api_version: @opts[:firewall_rules_api_version],
      },
    )
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermMariaDBServer < AzureMariaDBServer
  name 'azurerm_mariadb_server'
  desc 'Verifies settings for an Azure MariaDB Server'
  example <<-EXAMPLE
    describe azurerm_mariadb_server(resource_group: 'rg-1', server_name: 'my-server-name') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureMariaDBServer.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2018-06-01-preview'
    super
  end
end
