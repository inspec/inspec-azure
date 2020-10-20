resource_group = input('resource_group', value: nil)
storage_account = input('storage_account', value: nil)

control 'azure_storage_account' do
  describe azure_storage_account(resource_group: resource_group, name: storage_account) do
    it { should exist }
    it { should have_encryption_enabled }
    its('properties') { should have_attributes(supportsHttpsTrafficOnly: true) }
  end
end
