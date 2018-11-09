# frozen_string_literal: true

require 'azurerm_resource'

class AzurermMonitorActivityLogAlerts < AzurermPluralResource
  name 'azurerm_monitor_activity_log_alerts'
  desc 'Verifies settings for Azure Monitor Activity Log Alerts'
  example <<-EXAMPLE
    describe azurerm_monitor_activity_log_alerts do
      its('names') { should include('example-log-alert') }
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
             .register_column(:names, field: 'name')
             .register_column(:resource_group, field: 'resource_group')
             .register_column(:operations, field: 'operations')
             .install_filter_methods_on_resource(self, :table)

  def initialize
    resp = management.activity_log_alerts
    return if has_error?(resp)

    @table = resp.collect(&with_resource_group)
                 .collect(&with_operations)
  end

  include Azure::Deprecations::StringsInWhereClause

  def to_s
    'Activity Log Alerts'
  end

  def with_resource_group
    lambda do |group|
      # Get resource group from ID string
      name = group.id.split('/')[4]
      Azure::Response.create(group.members << :resource_group, group.values << name)
    end
  end

  def with_operations
    lambda do |alert|
      conditions = alert.properties.condition.allOf
      operations = conditions.find_all { |x| x.field == 'operationName' }.collect(&:equals)

      Azure::Response.create(alert.members << :operations, alert.values << operations)
    end
  end
end
