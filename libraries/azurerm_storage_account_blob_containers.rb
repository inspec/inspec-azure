# frozen_string_literal: true

require 'azurerm_resource'

class StorageAccountBlobContainers < AzurermPluralResource
  name 'azurerm_storage_account_blob_containers'
  desc 'Fetches all Blob Containers for an Azure Storage Account'
  example <<-EXAMPLE
    describe azurerm_storage_account_blob_containers(resource_group: 'rg', storage_account_name: 'sa') do
      its('names') { should include('my_blob_container') }
    end
  EXAMPLE

  FilterTable.create
             .register_column(:ids, field: 'id')
             .register_column(:names, field: 'name')
             .register_column(:etags, field: 'etag')
             .install_filter_methods_on_resource(self, :table)

  attr_reader :table

  def initialize(resource_group: nil, storage_account_name: nil)
    resp = management.blob_containers(resource_group, storage_account_name)
    return if has_error?(resp)

    @table = resp
  end

  def to_s
    'Storage Account Blob Containers'
  end
end
