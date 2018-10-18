# frozen_string_literal: true

require 'azurerm_resource'
require 'date'

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

  def has_recently_generated_access_key?
    now = Time.now
    ninety_days_ago = ((60*60)*(24*90))
    upper_bound = to_utc(now)
    lower_bound = to_utc(now - ninety_days_ago)

    filter = "resourceId eq '#{id}' and "\
             "eventTimestamp ge '#{lower_bound}' and "\
             "eventTimestamp le '#{upper_bound}' and "\
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
