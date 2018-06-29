# frozen_string_literal: true

require 'azurerm_resource'

class AzureMonitorLogProfile < AzurermResource
  name 'azure_monitor_log_profile'
  desc 'Verifies settings for a Azure Monitor Log Profile'
  example <<-EXAMPLE
    describe azure_monitor_log_profile(name: 'default') do
      it { should exist }
      its('retention_enabled') { should be true }
      its('retention_days')    { should eq(365) }
    end
  EXAMPLE

  ATTRS = {
    name:              'name',
    id:                'id',
    retention_policy:  'retentionPolicy',
    retention_days:    'retentionPolicyDays',
    retention_enabled: 'retentionPolicyEnabled',
  }.freeze

  attr_reader(*ATTRS.keys)

  def initialize(options = { name: 'default' })
    resp = client.log_profile(options[:name])
    return if resp.nil? || resp.key?('error')

    @name = resp['name']
    @id   = resp['id']
    @retention_policy  = resp['properties']['retentionPolicy']
    @retention_days    = resp['properties']['retentionPolicy']['days']
    @retention_enabled = resp['properties']['retentionPolicy']['enabled']

    ATTRS.each do |name, api_name|
      next if instance_variable_defined?("@#{name}")

      instance_variable_set("@#{name}", fields[api_name])
    end

    @exists = true
  end

  def has_log_retention_enabled?
    !!retention_enabled
  end

  def to_s
    "#{name} Log Profile"
  end
end
