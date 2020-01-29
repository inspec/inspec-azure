resource_group  = input('resource_group',  value: nil)
storage_account = input('storage_account', value: nil)

control 'azurerm_storage_accounts' do
  describe azurerm_storage_accounts do
    its('names') { should include(storage_account) }
  end

  describe azurerm_storage_accounts(resource_group: resource_group) do
    its('names') { should include(storage_account) }
  end
end
