require "azure_generic_resources"

class AzureSentinelIncidentsResources < AzureGenericResources
  name "azure_sentinel_incidents_resources"
  desc "List azure pipelines by  data factory."
  example <<-EXAMPLE
       describe azure_sentinel_incidents_resources(resource_group: resource_group, workspace_name: workspace_name) do
         it { should exist }
       end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)
    # Azure REST API endpoint URL format for the resource:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/
    #   providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/
    #   providers/Microsoft.SecurityInsights/incidents?api-version=2021-04-01
    opts[:resource_provider] = specific_resource_constraint("Microsoft.OperationalInsights/workspaces", opts)
    opts[:required_parameters] = %i(workspace_name)
    opts[:resource_path] = [opts[:workspace_name], "providers/Microsoft.SecurityInsights/incidents"].join("/")
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
    # Check if the resource is failed.
    # It is recommended to check that after every usage of superclass methods or API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    #   - column: It is defined as an instance method, callable on the resource, and present `field` values in a list.
    #   - field: It has to be identical with the `key` names in @table items that will be presented in the FilterTable.
    # @see https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md

    # FilterTable is populated at the very end due to being an expensive operation.
    populate_filter_table_from_response
  end

  def to_s
    super(AzureSentinelIncidentsResources)
  end

  private

  def flatten_hash(hash)
    hash.each_with_object({}) do |(k, v), h|
      if v.is_a? Hash
        flatten_hash(v).map do |h_k, h_v|
          h["#{k}_#{h_k}".to_sym] = h_v
        end
      else
        h[k] = v
      end
    end
  end

  def populate_table
    @resources.each do |resource|
      resource = resource.merge(resource[:properties])
      @table << flatten_hash(resource)
    end
  end
end
