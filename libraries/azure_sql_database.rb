require 'azure_generic_resource'

class AzureSqlDatabase < AzureGenericResource
  name 'azure_sql_database'
  desc 'Verifies settings for an Azure SQL Database'
  example <<-EXAMPLE
    describe azure_sql_database(resource_group: 'rg-1', server_name: 'sql-server-1' name: 'customer-db') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Sql/servers', opts)
    opts[:required_parameters] = %i(server_name)
    opts[:resource_path] = [opts[:server_name], 'databases'].join('/')
    opts[:resource_identifiers] = %i(database_name)
    opts[:allowed_parameters] = %i(auditing_settings_api_version
                                   threat_detection_settings_api_version
                                   encryption_settings_api_version)
    opts[:allowed_parameters].each do |param|
      opts[param] ||= 'latest'
    end
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureSqlDatabase)
  end

  # Resource specific methods can be created.
  # `return unless exists?` is necessary to prevent any unforeseen Ruby error.
  # Following methods are created to provide the same functionality with the current resource pack >>>>
  # @see https://github.com/inspec/inspec-azure

  # @see AzureKeyVault#diagnostic_settings for how to use #additional_resource_properties method.
  #
  def auditing_settings
    return unless exists?
    additional_resource_properties(
      {
        property_name: 'auditing_settings',
        property_endpoint: id + '/auditingSettings/default',
        api_version: @opts[:auditing_settings_api_version],
      },
    )
  end

  def threat_detection_settings
    return unless exists?
    additional_resource_properties(
      {
        property_name: 'threat_detection_settings',
        property_endpoint: id + '/securityAlertPolicies/default',
        api_version: @opts[:threat_detection_settings_api_version],
      },
    )
  end

  def encryption_settings
    return unless exists?
    additional_resource_properties(
      {
        property_name: 'encryption_settings',
        property_endpoint: id + '/transparentDataEncryption/current',
        api_version: @opts[:encryption_settings_api_version],
      },
    )
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermSqlDatabase < AzureSqlDatabase
  name 'azurerm_sql_database'
  desc 'Verifies settings for an Azure SQL Database'
  example <<-EXAMPLE
    describe azurerm_sql_database(resource_group: 'rg-1', server_name: 'sql-server-1' database_name: 'customer-db') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Ensure backward compatibility unless these properties are provided by the users deliberately.
    opts[:auditing_settings_api_version] ||= '2017-03-01-preview'
    opts[:threat_detection_settings_api_version] ||= '2014-04-01'
    opts[:encryption_settings_api_version] ||= '2014-04-01'

    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureSqlDatabase.name)
    super
  end
end
