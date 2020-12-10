require 'azure_generic_resources'

class AzureStorageAccountBlobContainers < AzureGenericResources
  name 'azure_storage_account_blob_containers'
  desc 'Fetches all Blob Containers for an Azure Storage Account'
  example <<-EXAMPLE
    describe azure_storage_account_blob_containers(resource_group: 'rg', storage_account_name: 'sa') do
      its('names') { should include('my_blob_container') }
    end
  EXAMPLE

  attr_reader :table

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Storage/storageAccounts', opts)
    opts[:required_parameters] = %i(resource_group storage_account_name)
    opts[:resource_path] = [opts[:storage_account_name], 'blobServices/default/containers'].join('/')

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)

    # Check if the resource is failed.
    # It is recommended to check that after every usage of inherited methods or making API calls.
    return if failed_resource?

    # Define the column and field names for FilterTable.
    # In most cases, the `column` should be the pluralized form of the `field`.
    # @see https://github.com/inspec/inspec/blob/master/docs/dev/filtertable-usage.md
    table_schema = [
      { column: :names, field: :name },
      { column: :ids, field: :id },
      { column: :tags, field: :tags },
      { column: :etags, field: :etag },
      { column: :locations, field: :location },
    ]

    # FilterTable is populated at the very end due to being an expensive operation.
    AzureGenericResources.populate_filter_table(:table, table_schema)
  end

  def to_s
    super(AzureStorageAccountBlobContainers)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class StorageAccountBlobContainers < AzureStorageAccountBlobContainers
  name 'azurerm_storage_account_blob_containers'
  desc 'Fetches all Blob Containers for an Azure Storage Account'
  example <<-EXAMPLE
    describe azurerm_storage_account_blob_containers(resource_group: 'rg', storage_account_name: 'sa') do
      its('names') { should include('my_blob_container') }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureStorageAccountBlobContainers.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2018-07-01'
    super
  end
end
