require 'azure_generic_resource'

class AzureSentinelAlertRule < AzureGenericResource
  name 'azure_sentinel_alert_rule'
  desc 'Verifies settings for an Sentinel Alert Rule'
  example <<-EXAMPLE
     describe azure_sentinel_alert_rule(resource_group: 'example', workspace_name: 'workspaceName', rule_id: 'rule_id') do
       it { should exit }
     end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.OperationalInsights/workspaces', opts)
    opts[:required_parameters] = %i(workspace_name)
    opts[:resource_path] = [opts[:workspace_name], 'providers/Microsoft.SecurityInsights/alertRules/'].join('/')
    opts[:resource_identifiers] = %i(rule_id)
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureSentinelAlertRule)
  end
end