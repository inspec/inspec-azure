resource_group = attribute('resource_group', value: nil)
storage_account = attribute('storage_account', value: nil)

control 'azurerm_storage_account' do
  describe azurerm_storage_account(resource_group: resource_group, name: storage_account) do
    it { should exist }
    its('properties') { should have_attributes(supportsHttpsTrafficOnly: true) }
  end
end
