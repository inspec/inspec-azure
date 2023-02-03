require "azure_generic_resource"

class AzureKeyVault < AzureGenericResource
  name "azure_key_vault"
  desc "Verifies settings and configuration for an Azure Key Vault"
  example <<-EXAMPLE
    describe azure_key_vault(resource_group: 'RESOURCE_GROUP_NAME', vault_name: 'vault-1') do
      it { should exist }
      its('name') { should eq('vault-1') }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format for the resource:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #   Microsoft.KeyVault/vaults/{vaultName}?api-version=2019-09-01
    #
    # The dynamic part that has to be created in this resource:
    #   Microsoft.KeyVault/vaults/{vaultName}?api-version=2019-09-01
    #
    # Parameters acquired from environment variables:
    #   - {subscriptionId} => Required parameter. It will be acquired by the backend from environment variables.
    #
    # For parameters applicable to all resources, see project's README.
    #
    # User supplied parameters:
    #   - resource_group => Required parameter unless `resource_id` is provided. {resourceGroupName}
    #   - name => Required parameter unless `resource_id` is provided. Name of the resource to be tested.
    #   - resource_id => Optional parameter. If exists, other resource related parameters must not be provided.
    #     In the following format:
    #       /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #       Microsoft.KeyVault/vaults/{vaultName}
    #   - api_version => Optional parameter. The latest version will be used unless provided.
    #
    #   **`resource_group`, (resource) `name` and `resource_id`  will be validated in the backend appropriately.
    #     We don't have to do anything here.
    #
    # Following resource parameters have to be defined/created here.
    #   resource_provider => Microsoft.KeyVault/vaults
    #     The `specific_resource_constraint` method will validate the user input
    #       not to accept a different `resource_provider`.
    #
    opts[:resource_provider] = specific_resource_constraint("Microsoft.KeyVault/vaults", opts)
    # Key vault name can be accepted with a different keyword, `vault_name`. `name` is default accepted.
    opts[:resource_identifiers] = %i(vault_name)
    opts[:allowed_parameters] = %i(diagnostic_settings_api_version)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # `api_version` is fixed for backward compatibility.
    @opts[:diagnostic_settings_api_version] ||= "2021-05-01-preview"
  end

  def to_s
    super(AzureKeyVault)
  end

  # Resource specific methods can be created.
  # `return unless exists?` is necessary to prevent any unforeseen Ruby error.
  # Following methods are created to provide the same functionality with the current resource pack >>>>
  # @see https://github.com/inspec/inspec-azure

  # Diagnostic settings can be acquired from:
  # GET https://management.azure.com/{resourceUri}/
  #   providers/microsoft.insights/diagnosticSettings?api-version=2017-05-01-preview
  # resource uri is the same as (resource) `id` of the key vault.
  #   @see: https://docs.microsoft.com/en-us/rest/api/monitor/diagnosticsettings/list
  #
  # `#additional_resource_properties` method will be used to get the diagnostic settings from the Rest API.
  #   property_name => The name of the properties, `diagnostic_settings`.
  #   property_endpoint => id + '/providers/microsoft.insights/diagnosticSettings'
  #   api_version => The api_version for the microsoft.insights/diagnosticSettings
  #     If not provided the `latest` version will be used. (RECOMMENDED)
  #
  def diagnostic_settings
    return unless exists?
    # `additional_resource_properties` method will create a singleton method with the `property_name`
    # and make api response available through this property.
    additional_resource_properties(
      {
        property_name: "diagnostic_settings",
        property_endpoint: "#{id}/providers/microsoft.insights/diagnosticSettings",
        api_version: @opts[:diagnostic_settings_api_version],
      },
    )
  end

  def diagnostic_settings_logs
    return nil if diagnostic_settings.nil? || diagnostic_settings.empty?
    result = []
    diagnostic_settings.each do |setting|
      logs = setting.properties&.logs
      next unless logs
      result += logs.map { |log| log.enabled if log.category }.compact
    end
    result
  end

  def has_logging_enabled?

    return false if diagnostic_settings.nil? || diagnostic_settings.empty?

    log = diagnostic_settings.each do |setting|
      log = setting.properties&.logs&.detect { |l|
              l.category == "AuditEvent" ||
        l.categoryGroup == "audit" ||
        l.categoryGroup == "allLogs" ||
        l.categoryGroup == "AllMetrics"}
      break log if log.present? && log.enabled?
    end
    log&.enabled
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermKeyVault < AzureKeyVault
  name "azurerm_key_vault"
  desc "Verifies settings and configuration for an Azure Key Vault"
  example <<-EXAMPLE
    describe azurerm_key_vault(resource_group: 'rg-1', vault_name: 'vault-1') do
      it            { should exist }
      its('name')   { should eq('vault-1') }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureKeyVault.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= "2016-10-01"
    super
  end
end
