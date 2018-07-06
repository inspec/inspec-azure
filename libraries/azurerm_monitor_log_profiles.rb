# frozen_string_literal: true

require 'azurerm_resource'

class AzurermMonitorLogProfiles < AzurermPluralResource
  name 'azurerm_monitor_log_profiles'
  desc 'Fetches all Azure Monitor Log Profiles'
  example <<-EXAMPLE
    describe azurerm_monitor_log_profiles do
      its('names') { should include('default') }
    end
  EXAMPLE

  FilterTable.create
             .register_column(:names, field: 'name')
             .install_filter_methods_on_resource(self, :table)

  def to_s
    'Log Profiles'
  end

  def table
    @table ||= client.log_profiles
  end
end
