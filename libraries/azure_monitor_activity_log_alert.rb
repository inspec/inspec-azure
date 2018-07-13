# frozen_string_literal: true

require 'azurerm_monitor_activity_log_alert'

class AzureMonitorActivityLogAlert < AzurermMonitorActivityLogAlert
  name 'azure_monitor_activity_log_alert'
  desc '[DEPRECATED] Please use the azurerm_monitor_activity_log_alert resource'
  example <<-EXAMPLE
    describe azure_monitor_activity_log_alert(resource_group: 'example', name: 'AlertName') do
      it { should exist }
      its('operations') { should include 'Microsoft.Authorization/policyAssignments/write' }
    end
  EXAMPLE

  def initialize(resource_group: nil, name: nil)
    warn '[DEPRECATION] The `azure_monitor_activity_log_alert` resource is deprecated and will be removed in version 2.0. Use the `azurerm_monitor_activity_log_alert` resource instead.'
    super
  end
end
