# frozen_string_literal: true

require 'azurerm_monitor_log_profile'

class AzureMonitorLogProfile < AzurermMonitorLogProfile
  name 'azure_monitor_log_profile'
  desc '[DEPRECATED] Please uze azurerm_monitor_log_profile'
  example <<-EXAMPLE
    describe azure_monitor_log_profile(name: 'default') do
      it { should exist }
      its('retention_enabled') { should be true }
      its('retention_days')    { should eq(365) }
    end
  EXAMPLE

  def initialize(options = { name: 'default' })
    warn '[DEPRECATION] The `azure_monitor_log_profile` resource is ' \
         'deprecated and will be removed in version 2.0. Use the ' \
         '`azurerm_monitor_log_profile` resource instead.'
    super
  end
end
