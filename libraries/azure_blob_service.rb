require 'azure_generic_resource'

class AzureBlobService < AzureGenericResource
  name 'azure_blob_service'
  desc 'Verifies settings for an Azure API Blob Service.'
  example <<-EXAMPLE
    describe azure_blob_service(resource_group: 'resource-group-name', storage_account_name: 'storage-account-name') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)
    opts[:resource_provider] = specific_resource_constraint('Microsoft.Storage/storageAccounts', opts)
    opts[:required_parameters] = %i(storage_account_name)
    opts[:name] = 'default'
    opts[:resource_path] = [opts[:storage_account_name], 'blobServices'].join('/')
    opts[:method] = 'get'
    super(opts, true)
  end

  def to_s
    super(AzureBlobService)
  end
end
