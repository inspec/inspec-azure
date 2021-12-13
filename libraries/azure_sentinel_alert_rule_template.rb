require 'azure_generic_resource'

class AzureSentinelAlertRuleTemplate < AzureGenericResource
  name 'azure_sentinel_alert_rule_template'
  desc 'Verifies settings for an Sentinel Alert Rule Template'
  example <<-EXAMPLE
    describe azure_alert_rule_template(resource_group: 'example', workspace_name: 'workspaceName', alert_rule_template_id: 'alert_rule_template_id') do
      it { should exit }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.OperationalInsights/workspaces', opts)
    opts[:required_parameters] = %i(workspace_name)
    opts[:resource_path] = [opts[:workspace_name], 'providers/Microsoft.SecurityInsights/alertRuleTemplates/'].join('/')
    opts[:resource_identifiers] = %i(alert_rule_template_id)
    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureSentinelAlertRuleTemplate)
  end
end
