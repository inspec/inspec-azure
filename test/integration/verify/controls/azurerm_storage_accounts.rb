resource_group  = input('resource_group',  value: nil)
storage_account = input('storage_account', value: nil)
location        = input('vnet_location',   value:nil)

control 'azurerm_storage_accounts' do
  describe azurerm_storage_accounts do
    its('names')    { should include(storage_account) }
    its('location') { should include(location) }
  end

  describe azurerm_storage_accounts(resource_group: resource_group) do
    its('names')    { should include(storage_account) }
    its('location') { should include(location) }
  end
end
