require "azure_generic_resources"

class AzureResourceGroups < AzureGenericResources
  name "azure_resource_groups"
  desc "Fetches all available resource groups"
  example <<-EXAMPLE
    describe azure_resource_groups do
      its('names') { should include('example-group') }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("/resourcegroups/", opts)
    # See azure_policy_definitions resource for how to use `resource_uri` and `add_subscription_id` parameters.
    opts[:resource_uri] = "/resourcegroups/"
    opts[:add_subscription_id] = true

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
    super(AzureResourceGroups)
  end

  private

  # This is for backward compatibility.
  def populate_table
    return [] if @resources.empty?
    @resources.each do |resource|
      @table << {
        id: resource[:id],
        name: resource[:name],
        tags: resource[:tags].nil? ? {} : resource[:tags].transform_keys(&:to_s),
        location: resource[:location],
      }
    end
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermResourceGroups < AzureResourceGroups
  name "azurerm_resource_groups"
  desc "Fetches all available resource groups"
  example <<-EXAMPLE
    describe azurerm_resource_groups do
      its('names') { should include('example-group') }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureResourceGroups.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= "2018-02-01"
    super
  end
end
