require 'azure_generic_resource'

class AzureSqlServer < AzureGenericResource
  name 'azure_sql_server'
  desc 'Verifies settings for an Azure SQL Server'
  example <<-EXAMPLE
    describe azure_sql_server(resource_group: 'rg-1', name: 'my-server-name') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Sql/servers', opts)

    opts[:resource_identifiers] = %i(server_name)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureSqlServer)
  end

  # Resource specific methods can be created.
  # `return unless exists?` is necessary to prevent any unforeseen Ruby error.
  # Following methods are created to provide the same functionality with the current resource pack >>>>
  # @see https://github.com/inspec/inspec-azure

  # @see AzureKeyVault#diagnostic_settings for how to use #create_additional_properties method.
  #
  def firewall_rules
    return unless exists?
    create_additional_properties(
      {
        property_name: 'firewall_rules',
        property_endpoint: id + '/firewallRules',
      },
    )
  end

  def auditing_settings
    return unless exists?
    create_additional_properties(
      {
        property_name: 'auditing_settings',
        property_endpoint: id + '/auditingSettings/default',
      },
    )
  end

  def threat_detection_settings
    return unless exists?
    create_additional_properties(
      {
        property_name: 'threat_detection_settings',
        property_endpoint: id + '/securityAlertPolicies/Default',
      },
    )
  end

  def administrators
    return unless exists?
    create_additional_properties(
      {
        property_name: 'administrators',
        property_endpoint: id + '/administrators',
      },
    )
  end

  def encryption_protector
    return unless exists?
    create_additional_properties(
      {
        property_name: 'encryption_protector',
        property_endpoint: id + '/encryptionProtector',
      },
    )
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermSqlServer < AzureSqlServer
  name 'azurerm_sql_server'
  desc 'Verifies settings for an Azure SQL Server'
  example <<-EXAMPLE
    describe azurerm_sql_server(resource_group: 'rg-1', server_name: 'my-server-name') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureSqlServer.name)
    super
  end
end
