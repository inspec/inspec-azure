storage_account = attribute('storage_account', default: nil)

control 'azurerm_storage_accounts' do
  describe azurerm_storage_accounts do
    its('names') { should include(storage_account) }
  end
end
