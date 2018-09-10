resource_group = attribute('resource_group', default: nil)
storage_account = attribute('storage_account', default: nil)

control 'azurerm_storage_account' do
  describe azurerm_storage_account(resource_group: resource_group, name: storage_account) do
    it { should exist }
    its('secure_transfer_enabled') { should be true }
  end
end
