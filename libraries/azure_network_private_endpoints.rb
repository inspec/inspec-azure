require 'azure_generic_resources'

class AzureNetworkPrivateEndpoints < AzureGenericResources
  name 'azure_network_private_endpoints'
  desc 'Verifies settings for a collection of Azure Network Private Endpoints'
  example <<-EXAMPLE
    describe azure_network_private_endpoints do
      it { should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/privateEndpoints', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    table_schema = [
      { column: :names, field: :name },
      { column: :ids, field: :id },
      { column: :tags, field: :tags },
      { column: :types, field: :type },
      { column: :locations, field: :location },
      { column: :properties, field: :properties },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureNetworkPrivateEndpoints)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermNetworkPrivateEndpoints < AzureNetworkPrivateEndpoints
  name 'azurerm_network_private_endpoints'
  desc 'Verifies settings for a collection of Azure Network Private Endpoints'
  example <<-EXAMPLE
    describe azurerm_network_private_endpoints do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureNetworkPrivateEndpoints.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    super
  end
end
