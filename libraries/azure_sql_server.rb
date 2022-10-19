require 'azure_generic_resource'

class AzureSqlServer < AzureGenericResource
  name 'azure_sql_server'
  desc 'Verifies settings for an Azure SQL Server.'
  example <<-EXAMPLE
    describe azure_sql_server(resource_group: 'RESOURCE_GROUP_NAME', name: 'SERVER_NAME') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Sql/servers', opts)
    opts[:resource_identifiers] = %i(server_name)
    opts[:allowed_parameters] = %i(firewall_rules_api_version auditing_settings_api_version
                                   threat_detection_settings_api_version administrators_api_version
                                   encryption_protector_api_version)
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    @opts[:allowed_parameters].each do |param|
      @opts[param] ||= 'latest'
    end
  end

  def to_s
    super(AzureSqlServer)
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

  def auditing_settings
    return unless exists?
    additional_resource_properties(
      {
        property_name: 'auditing_settings',
        property_endpoint: "#{id}/auditingSettings/default",
        api_version: @opts[:auditing_settings_api_version],
      },
    )
  end

  def threat_detection_settings
    return unless exists?
    additional_resource_properties(
      {
        property_name: 'threat_detection_settings',
        property_endpoint: "#{id}/securityAlertPolicies/Default",
        api_version: @opts[:threat_detection_settings_api_version],
      },
    )
  end

  def administrators
    return unless exists?
    additional_resource_properties(
      {
        property_name: 'administrators',
        property_endpoint: "#{id}/administrators",
        api_version: @opts[:administrators_api_version],
      },
    )
  end

  def encryption_protector
    return unless exists?
    additional_resource_properties(
      {
        property_name: 'encryption_protector',
        property_endpoint: "#{id}/encryptionProtector",
        api_version: @opts[:encryption_protector_api_version],
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
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2018-06-01-preview'
    opts[:firewall_rules_api_version] ||= '2014-04-01'
    opts[:auditing_settings_api_version] ||= '2017-03-01-preview'
    opts[:threat_detection_settings_api_version] ||= '2017-03-01-preview'
    opts[:administrators_api_version] ||= '2014-04-01'
    opts[:encryption_protector_api_version] ||= '2015-05-01-preview'
    super
  end
end
