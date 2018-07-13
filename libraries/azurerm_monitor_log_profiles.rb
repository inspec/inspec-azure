# frozen_string_literal: true

require 'azurerm_resource'

class AzurermMonitorLogProfiles < AzurermResource
  name 'azurerm_monitor_log_profiles'
  desc 'Fetches all Azure Monitor Log Profiles'
  example <<-EXAMPLE
    describe azurerm_monitor_log_profiles do
      its('names') { should include('default') }
    end
  EXAMPLE

  FilterTable.create
             .add_accessor(:entries)
             .add_accessor(:where)
             .add(:exists?) { |obj| !obj.entries.empty? }
             .add(:names, field: 'name')
             .connect(self, :table)

  def to_s
    'Log Profiles'
  end

  def table
    @table ||= client.log_profiles
  end
end
