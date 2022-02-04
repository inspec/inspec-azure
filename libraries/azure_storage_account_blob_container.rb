require 'azure_generic_resource'

class AzureStorageAccountBlobContainer < AzureGenericResource
  name 'azure_storage_account_blob_container'
  desc 'Verifies settings for a Azure Storage Account Blob Container'
  example <<-EXAMPLE
    describe azure_storage_account_blob_container(resource_group: 'rg',
                                                    storage_account_name: 'default',
                                                    name: 'logs') do
      it          { should exist }
      its('name') { should eq('logs') }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Storage/storageAccounts', opts)
    opts[:required_parameters] = %i(storage_account_name)
    opts[:resource_path] = [opts[:storage_account_name], 'blobServices/default/containers'].join('/')
    opts[:resource_identifiers] = %i(blob_container_name)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureStorageAccountBlobContainer)
  end
end
