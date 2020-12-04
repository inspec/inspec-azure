require 'azure_generic_resources'

class AzureNetworkWatchers < AzureGenericResources
  name 'azure_network_watchers'
  desc 'Verifies settings for Network Watchers'
  example <<-EXAMPLE
    azure_network_watchers(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Network/networkWatchers', opts)
    opts[:allowed_parameters] = %i(resource_group)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    # @see https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md
    table_schema = [
      { column: :names, field: :name },
      { column: :ids, field: :id },
      { column: :tags, field: :tags },
      { column: :locations, field: :location },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureNetworkWatchers)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermNetworkWatchers < AzureNetworkWatchers
  name 'azurerm_network_watchers'
  desc 'Verifies settings for Network Watchers'
  example <<-EXAMPLE
    azurerm_network_watchers(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureNetworkWatchers.name)
    super
  end
end
