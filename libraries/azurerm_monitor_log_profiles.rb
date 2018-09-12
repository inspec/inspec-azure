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

  attr_reader :table

  def initialize
    resp = management.log_profiles
    return if has_error?(resp)

    @table = resp
  end

  include Azure::Deprecations::StringsInWhereClause

  def to_s
    'Log Profiles'
  end
end
