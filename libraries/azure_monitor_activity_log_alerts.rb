# frozen_string_literal: true

require 'azurerm_monitor_activity_log_alerts'

class AzureMonitorActivityLogAlerts < AzurermMonitorActivityLogAlerts
  name 'azure_monitor_activity_log_alerts'
  desc '[DEPRECATED] Please use the azurerm_monitor_activity_log_alerts resource'
  example <<-EXAMPLE
    describe azure_monitor_activity_log_alerts do
      its('names') { should include('example-log-alert') }
    end
  EXAMPLE

  def initialize
    warn '[DEPRECATION] The `azure_monitor_activity_log_alerts` resource is deprecated and will be removed in version 2.0. Use the `azurerm_monitor_activity_log_alerts` resource instead.'
    super
  end
end
