require 'azure_generic_resource'

class AzureMonitorActivityLogAlert < AzureGenericResource
  name 'azure_monitor_activity_log_alert'
  desc 'Verifies settings for a Azure Monitor Activity Log Alert'
  example <<-EXAMPLE
    describe azure_monitor_activity_log_alert(resource_group: 'example', name: 'AlertName') do
      it { should exist }
      its('operations') { should include 'Microsoft.Authorization/policyAssignments/write' }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Insights/activityLogAlerts', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def conditions
    return unless exists?
    properties&.condition&.allOf
  end

  def operations
    return unless exists?
    conditions&.select { |x| x.field == 'operationName' }&.collect(&:equals)
  end

  def scopes
    return unless exists?
    properties&.scopes&.map { |scope| scope.delete_suffix('/') }
  end

  def enabled?
    return unless exists?
    properties&.enabled
  end

  def to_s
    super(AzureMonitorActivityLogAlert)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermMonitorActivityLogAlert < AzureMonitorActivityLogAlert
  name 'azurerm_monitor_activity_log_alert'
  desc 'Verifies settings for a Azure Monitor Activity Log Alert'
  example <<-EXAMPLE
    describe azurerm_monitor_activity_log_alert(resource_group: 'example', name: 'AlertName') do
      it { should exist }
      its('operations') { should include 'Microsoft.Authorization/policyAssignments/write' }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureMonitorActivityLogAlert.name)
    super
  end
end
