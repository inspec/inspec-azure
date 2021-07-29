require 'azure_generic_resource'
require 'active_support/core_ext/hash'

class AzureStorageAccount < AzureGenericResource
  name 'azure_storage_account'
  desc 'Verifies settings for a Azure Storage Account'
  example <<-EXAMPLE
    describe azure_storage_account(resource_group: 'r-group', name: 'default') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Storage/storageAccounts', opts)
    opts[:allowed_parameters] = %i(activity_log_alert_api_version storage_service_endpoint_api_version)
    # fall-back `api_version` is fixed for now.
    # TODO: Implement getting the latest Azure Storage services api version
    opts[:storage_service_endpoint_api_version] ||= '2019-12-12'
    opts[:activity_log_alert_api_version] ||= 'latest'

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureStorageAccount)
  end
    

  # Resource specific methods can be created.
  # `return unless exists?` is necessary to prevent any unforeseen Ruby error.
  # Following methods are created to provide the same functionality with the current resource pack >>>>
  # @see https://github.com/inspec/inspec-azure

  def has_recently_generated_access_key?
    return unless exists?
    now = Time.now
    ninety_days_ago = ((60*60)*(24*90))
    upper_bound = to_utc(now)
    lower_bound = to_utc(now - ninety_days_ago)

    if properties.creationTime > lower_bound
      return true
    end
    
    filter = "resourceId eq '#{id}' and "\
             "eventTimestamp ge '#{lower_bound}' and "\
             "eventTimestamp le '#{upper_bound}' and "\
             "operations eq 'Microsoft.Storage/storageAccounts/regeneratekey/action'"
    activity_log_alert_filter(filter) unless respond_to?(:activity_log_alert_filtered)
    activity_log_alert_filtered.any?
  end

  def has_encryption_enabled?
    return unless exists?
    properties.encryption.services.blob.enabled || false
  end

  def queues
    return unless exists?
    url = "https://#{name}.queue#{@azure.storage_endpoint_suffix}"
    params = { comp: 'list' }
    # Calls to Azure Storage resources requires a special header `x-ms-version`
    # https://docs.microsoft.com/en-us/rest/api/storageservices/versioning-for-the-azure-storage-services
    headers = { 'x-ms-version' => @opts[:storage_service_endpoint_api_version] }
    body = @azure.rest_api_call(url: url, params: params, headers: headers)
    return unless body
    body_hash = Hash.from_xml(body)
    hash_with_snakecase_keys = RecursiveMethodHelper.method_recursive(body_hash, :snakecase)
    if hash_with_snakecase_keys
      create_resource_methods({ queues: hash_with_snakecase_keys })
      public_send(:queues) if respond_to?(:queues)
    end
  end

  def queue_properties
    return unless exists?
    url = "https://#{name}.queue#{@azure.storage_endpoint_suffix}"
    params = { restype: 'service', comp: 'properties' }
    # @see #queues for the header `x-ms-version`
    headers = { 'x-ms-version' => @opts[:storage_service_endpoint_api_version] }
    body = @azure.rest_api_call(url: url, params: params, headers: headers)
    return unless body
    body_hash = Hash.from_xml(body)
    hash_with_snakecase_keys = RecursiveMethodHelper.method_recursive(body_hash, :snakecase)
    properties = hash_with_snakecase_keys['storage_service_properties']
    if properties
      create_resource_methods({ queue_properties: properties })
      public_send(:queue_properties) if respond_to?(:queue_properties)
    end
  end

  def blobs
    return unless exists?
    url = "https://#{name}.blob#{@azure.storage_endpoint_suffix}"
    params = { comp: 'list' }
    # Calls to Azure Storage resources requires a special header `x-ms-version`
    # https://docs.microsoft.com/en-us/rest/api/storageservices/versioning-for-the-azure-storage-services
    headers = { 'x-ms-version' => @opts[:storage_service_endpoint_api_version] }
    body = @azure.rest_api_call(url: url, params: params, headers: headers)
    return unless body
    body_hash = Hash.from_xml(body)
    hash_with_snakecase_keys = RecursiveMethodHelper.method_recursive(body_hash, :snakecase)
    if hash_with_snakecase_keys
      create_resource_methods({ blobs: hash_with_snakecase_keys })
      public_send(:blobs) if respond_to?(:blobs)
    end
  end

  def blob_properties
    return unless exists?
    url = "https://#{name}.blob#{@azure.storage_endpoint_suffix}"
    params = { restype: 'service', comp: 'properties' }
    # @see #queues for the header `x-ms-version`
    headers = { 'x-ms-version' => @opts[:storage_service_endpoint_api_version] }
    body = @azure.rest_api_call(url: url, params: params, headers: headers)
    return unless body
    body_hash = Hash.from_xml(body)
    hash_with_snakecase_keys = RecursiveMethodHelper.method_recursive(body_hash, :snakecase)
    properties = hash_with_snakecase_keys['storage_service_properties']
    if properties
      create_resource_methods({ blob_properties: properties })
      public_send(:blob_properties) if respond_to?(:blob_properties)
    end
  end

  def table_properties
    return unless exists?
    url = "https://#{name}.table#{@azure.storage_endpoint_suffix}"
    params = { restype: 'service', comp: 'properties' }
    # @see #queues for the header `x-ms-version`
    headers = { 'x-ms-version' => @opts[:storage_service_endpoint_api_version] }
    body = @azure.rest_api_call(url: url, params: params, headers: headers)
    return unless body
    body_hash = Hash.from_xml(body)
    hash_with_snakecase_keys = RecursiveMethodHelper.method_recursive(body_hash, :snakecase)
    properties = hash_with_snakecase_keys['storage_service_properties']
    if properties
      create_resource_methods({ table_properties: properties })
      public_send(:table_properties) if respond_to?(:table_properties)
    end
  end

  private

  # @see AzureKeyVault#diagnostic_settings for how to use #additional_resource_properties method.
  #
  def activity_log_alert_filter(filter)
    return unless exists?
    # `additional_resource_properties` method will create a singleton method with the `property_name`
    # and make api response available through this property.
    additional_resource_properties(
      {
        property_name: 'activity_log_alert_filtered',
        property_endpoint: '/providers/microsoft.insights/eventtypes/management/values',
        add_subscription_id: true,
        api_version: @opts[:activity_log_alert_api_version],
        filter_free_text: filter,
      },
    )
  end

  def to_utc(datetime)
    # API requires times in UTC ISO8601 format.
    datetime.to_time.utc.iso8601
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermStorageAccount < AzureStorageAccount
  name 'azurerm_storage_account'
  desc 'Verifies settings for a Azure Storage Account'
  example <<-EXAMPLE
    describe azurerm_storage_account(resource_group: resource_name, name: 'default') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureStorageAccount.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2017-06-01'
    super
  end
end
