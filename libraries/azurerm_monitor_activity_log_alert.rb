# frozen_string_literal: true

require 'azurerm_resource'

class AzurermMonitorActivityLogAlert < AzurermSingularResource
  name 'azurerm_monitor_activity_log_alert'
  desc 'Verifies settings for a Azure Monitor Activity Log Alert'
  example <<-EXAMPLE
    describe azurerm_monitor_activity_log_alert(resource_group: 'example', name: 'AlertName') do
      it { should exist }
      its('operations') { should include 'Microsoft.Authorization/policyAssignments/write' }
    end
  EXAMPLE

  ATTRS = %i(
    name
    id
    conditions
    operations
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, name: nil)
    resp = management.activity_log_alert(resource_group, name)
    return if has_error?(resp)

    @name       = resp.name
    @id         = resp.id
    @conditions = resp.properties.condition.allOf
    @operations = collect_operations(@conditions)

    @exists = true
  end

  def to_s
    "#{name} Activity Log Alert"
  end

  private

  # Collect all Operation strings for the Activity Log Alert
  #
  # @param [Hash] 'allOf' conditions from response properties
  # @return [Array] of operation strings
  def collect_operations(conditions)
    conditions.find_all { |x| x.field == 'operationName' }.collect(&:equals)
  end
end
