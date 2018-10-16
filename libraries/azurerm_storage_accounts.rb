# frozen_string_literal: true

require 'azurerm_resource'

class StorageAccounts < AzurermPluralResource
  name 'azurerm_storage_accounts'
  desc 'Fetches all Azure Storage Accounts'
  example <<-EXAMPLE
    describe azurerm_storage_accounts do
      its('names') { should include('default') }
    end
  EXAMPLE

  FilterTable.create
             .register_column(:names, field: 'name')
             .install_filter_methods_on_resource(self, :table)

  attr_reader :table

  def initialize(resource_group: nil)
    resp = management.storage_accounts(resource_group)
    return if has_error?(resp)

    @table = resp
  end

  def to_s
    'Storage Accounts'
  end
end
