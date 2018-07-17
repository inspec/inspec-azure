# frozen_string_literal: true

require 'azurerm_monitor_log_profiles'

class AzureMonitorLogProfiles < AzurermMonitorLogProfiles
  name 'azure_monitor_log_profiles'
  desc '[DEPRECATED] Please use azurerm_monitor_log_profiles'
  example <<-EXAMPLE
    describe azure_monitor_log_profiles do
      its('names') { should include('default') }
    end
  EXAMPLE

  def initialize
    warn '[DEPRECATION] The `azure_monitor_log_profiles` resource is ' \
         'deprecated and will be removed in version 2.0. Use the ' \
         '`azurerm_monitor_log_profiles` resource instead.'
    super
  end
end
