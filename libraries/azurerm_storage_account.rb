# frozen_string_literal: true

require 'azurerm_resource'
require 'date'
require 'time'

class AzurermStorageAccout < AzurermSingularResource
  name 'azurerm_storage_account'
  desc 'Verifies settings for a Azure Storage Account'
  example <<-EXAMPLE
    describe azurerm_storage_account(resource_group: resource_name, name: 'default') do
      it { should exist }
      its('secure_transfer_enabled') { should be true }
    end
  EXAMPLE

  ATTRS = %i(
    name
    id
    properties
  ).freeze

  attr_reader(*ATTRS)

  def initialize(name: 'default', resource_group: nil)
    storage_account = management.storage_account(resource_group, name)
    return if has_error?(storage_account)

    assign_fields(ATTRS, storage_account)

    @exists = true
  end

  def have_recently_generated_access_key
    now = DateTime.now
    less_than = to_utc(now)
    greater_than = to_utc(now-90)

    filter = "resourceId eq '#{id}' and "\
             "eventTimestamp ge '#{greater_than}' and "\
             "eventTimestamp le '#{less_than}' and "\
             "operations eq 'Microsoft.Storage/storageAccounts/regeneratekey/action'"

    log_events = management.activity_log_alert_filtered(filter)
    log_events.any?
  end

  def to_s
    "#{name} Storage Account"
  end

  private

  def to_utc(datetime)
    # API requires times in UTC ISO8601 format.
    datetime.to_time.utc.iso8601
  end
end
