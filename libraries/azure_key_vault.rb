require 'azure_generic_resource'

class AzureKeyVault < AzureGenericResource
  name 'azure_key_vault'
  desc 'Verifies settings and configuration for an Azure Key Vault'
  example <<-EXAMPLE
    describe azure_key_vault(resource_group: 'rg-1', vault_name: 'vault-1') do
      it            { should exist }
      its('name')   { should eq('vault-1') }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

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
    opts[:resource_provider] = specific_resource_constraint('Microsoft.KeyVault/vaults', opts)
    # Key vault name can be accepted with a different keyword, `vault_name`. `name` is default accepted.
    opts[:resource_identifiers] = %i(vault_name)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
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
  # `#get_resource` method will be used to get the diagnostic settings from the Rest API.
  #   api_version => the api_version for the microsoft.insights/diagnosticSettings
  #   resource_uri => id + '/providers/microsoft.insights/diagnosticSettings'
  #
  def diagnostic_settings
    return unless exists?
    if @diagnostic_settings.nil?
      resource_uri = id + '/providers/microsoft.insights/diagnosticSettings'
      api_query_diagnostic_settings = {
        resource_uri: resource_uri,
        # api_version is fixed due to this operation is not supported by other versions.
        api_version: '2017-05-01-preview',
      }
      # The `:value` will return the diagnostic settings.
      @diagnostic_settings = get_resource(api_query_diagnostic_settings)[:value]
    end
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermKeyVault < AzureKeyVault
  name 'azurerm_key_vault'
  desc 'Verifies settings and configuration for an Azure Key Vault'
  example <<-EXAMPLE
    describe azurerm_key_vault(resource_group: 'rg-1', vault_name: 'vault-1') do
      it            { should exist }
      its('name')   { should eq('vault-1') }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureKeyVault.name)
    super
  end
end
