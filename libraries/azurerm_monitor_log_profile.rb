# frozen_string_literal: true

require "azurerm_resource"

class AzurermMonitorLogProfile < AzurermSingularResource
  name "azurerm_monitor_log_profile"
  desc "Verifies settings for a Azure Monitor Log Profile"
  example <<-EXAMPLE
    describe azurerm_monitor_log_profile(name: 'default') do
      it { should exist }
      its('retention_enabled') { should be true }
      its('retention_days')    { should eq(365) }
    end
  EXAMPLE

  ATTRS = %i{
    name
    id
    properties
    retention_policy
    retention_days
    retention_enabled
    storage_account
  }.freeze

  attr_reader(*ATTRS)

  def initialize(options = { name: "default" })
    resp = management.log_profile(options[:name])
    return if has_error?(resp)

    @name              = resp.name
    @id                = resp.id
    @retention_policy  = resp.properties.retentionPolicy
    @retention_days    = resp.properties.retentionPolicy.days
    @retention_enabled = resp.properties.retentionPolicy.enabled
    @properties        = resp.properties

    sa = id_to_h(resp.properties.storageAccountId)
    @storage_account = { name: sa[:storage_accounts], resource_group: sa[:resource_groups] }
    @exists = true
  end

  def has_log_retention_enabled?
    !!retention_enabled
  end

  def to_s
    "#{name} Log Profile"
  end
end
