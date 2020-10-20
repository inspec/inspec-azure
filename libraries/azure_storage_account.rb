require 'azurerm_resource'

class AzureStorageAccount < AzureGenericResource
  name 'azure_storage_account'
  desc 'Verifies settings for a Azure Storage Account'
  example <<-EXAMPLE
    describe azure_storage_account(resource_group: resource_name, name: 'default') do
      it { should exist }
      its('secure_transfer_enabled') { should be true }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in a Hash object.' unless opts.is_a?(Hash)
    opts[:resource_provider] = specific_resource_constraint('Microsoft.Storage/storageAccounts', opts)
    opts[:resource_identifiers] = %i(storage_account_name)

    # static_resource parameter must be true for setting the resource_provider in the backend.\
    super(opts, true)
  end

  def to_s
    super(AzureStorageAccount)
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

  def has_encryption_enabled?
    properties.encryption.services.blob.enabled || false
  end

  def queues
    @queues ||= queue(name).queues
  end

  def queue_properties
    @queue_properties ||= queue(name).queue_properties
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

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermStorageAccount < AzureStorageAccount
  name 'azurerm_storage_account'
  desc 'Verifies settings for an Azure Storage Account'
  example <<-EXAMPLE
    describe azurerm_storage_account(resource_group: 'rg-1', name: 'sa1') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureStorageAccount.name)
    super
  end
end
