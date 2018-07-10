# frozen_string_literal: true

require 'azurerm_resource'

class AzureMonitorActivityLogAlert < AzurermResource
  name 'azure_monitor_activity_log_alert'
  desc 'Verifies settings for a Azure Monitor Activity Log Alert'
  example <<-EXAMPLE
    describe azure_monitor_activity_log_alert(resource_group: 'example', name: 'AlertName') do
      it { should exist }
      its('operations') { should include 'Microsoft.Authorization/policyAssignments/write' }
    end
  EXAMPLE

  ATTRS = {
    name:       'name',
    id:         'id',
    conditions: 'conditionAllOf',
    operations: 'operations',
  }.freeze

  attr_reader(*ATTRS.keys)

  def initialize(resource_group: nil, name: nil)
    resp = client.activity_log_alert(resource_group, name)
    return if resp.nil? || resp.key?('error')

    @name       = resp['name']
    @id         = resp['id']
    @conditions = resp['properties']['condition']['allOf']
    @operations = collect_operations(@conditions)

    ATTRS.each do |attr_name, api_name|
      next if instance_variable_defined?("@#{attr_name}")

      instance_variable_set("@#{name}", fields[api_name])
    end

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
    conditions.find_all { |x| x['field'] == 'operationName' }.collect { |x| x['equals'] }
  end
end
