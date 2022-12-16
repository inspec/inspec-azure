require "azure_generic_resource"

class AzureSentinelIncidentsResource < AzureGenericResource
  name "azure_sentinel_incidents_resource"
  desc "get azure gateway unr ta factory."
  example <<-EXAMPLE
       describe azure_sentinel_incidents_resource(resource_group: resource_group, workspace_name: workspace_name, incident_id: incident_id)  do
         it { should exist }
       end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)
    #
    # Azure REST API endpoint URL format for the resource:
    #   GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/
    #   providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/
    #   providers/Microsoft.SecurityInsights/incidents/{incidentId}?api-version=2021-04-01
    #
    opts[:resource_provider] = specific_resource_constraint("Microsoft.OperationalInsights/workspaces", opts)
    opts[:required_parameters] = %i(workspace_name)
    opts[:resource_path] = [opts[:workspace_name], "providers/Microsoft.SecurityInsights/incidents/"].join("/")
    opts[:resource_identifiers] = %i(incident_id)
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureSentinelIncidentsResource)
  end
end
