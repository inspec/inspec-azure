require 'azure_generic_resources'

class AzureKeyVaults < AzureGenericResources
  name 'azure_key_vaults'
  desc 'Verifies settings for a collection of Azure Key Vaults'
  example <<-EXAMPLE
    describe azurerm_key_vaults(resource_group: 'rg-1') do
        it              { should exist }
        its('names')    { should include 'vault-1'}
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # Azure REST API endpoint URL format listing the all resources for a given subscription:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/providers/
    #   Microsoft.KeyVault/vaults?api-version=2019-09-01
    #
    # or in a resource group only
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/
    #   Microsoft.KeyVault/vaults?api-version=2019-09-01
    #
    # The dynamic part that has to be created for this resource:
    #   Microsoft.KeyVault/vaults?api-version=2019-09-01
    #
    # Parameters acquired from environment variables:
    #   - {subscriptionId} => Required parameter. It will be acquired by the backend from environment variables.
    #
    # For parameters applicable to all resources, see project's README.
    #
    # User supplied parameters:
    #   - resource_group => Optional parameter.
    #   - api_version => Optional parameter. The latest version will be used unless provided.
    #
    #   **`resource_group`  will be used in the backend appropriately.
    #     We don't have to do anything here.
    #
    # Following resource parameters have to be defined here.
    #   - resource_provider => Microsoft.KeyVault/vaults
    #     The `specific_resource_constraint` method will validate the user input
    #       not to accept a different `resource_provider`.

    opts[:resource_provider] = specific_resource_constraint('Microsoft.KeyVault/vaults', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    # @see https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md
    table_schema = [
      { column: :ids, field: :id },
      { column: :names, field: :name },
      { column: :locations, field: :location },
      { column: :types, field: :type },
      { column: :tags, field: :tags },
      { column: :properties, field: :properties },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureKeyVaults)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermKeyVaults < AzureKeyVaults
  name 'azurerm_key_vaults'
  desc 'Verifies settings for a collection of Azure Key Vaults'
  example <<-EXAMPLE
    describe azurerm_key_vaults(resource_group: 'rg-1') do
        it              { should exist }
        its('names')    { should include 'vault-1'}
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureKeyVaults.name)
    super
  end
end
