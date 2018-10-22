# frozen_string_literal: true

require 'azurerm_resource'

class AzurermStorageAccoutBlobContainer < AzurermSingularResource
  name 'azurerm_storage_account_blob_container'
  desc 'Verifies settings for a Azure Storage Account Blob Container'
  example <<-EXAMPLE
    describe azurerm_storage_account_blob_container(resource_group: 'rg',
                                                    storage_account_name: 'default',
                                                    blob_container_name: 'logs') do
      it          { should exist }
      its('name') { should eq('logs') }
    end
  EXAMPLE

  ATTRS = %i(
    id
    name
    etag
    properties
    type
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, storage_account_name: nil, blob_container_name: nil)
    resp = management.blob_container(resource_group, storage_account_name, blob_container_name)
    return if has_error?(resp)

    assign_fields(ATTRS, resp)

    @exists = true
  end

  def to_s
    "#{name} Storage Account"
  end
end
