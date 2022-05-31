resource_group = input('resource_group', value: nil)
storage_account = input('storage_account', value: nil)
blob_container = input('storage_account_blob_container', value: nil)

control 'azurerm_storage_account_blob_container' do

  impact 1.0
  title 'Testing the singular resource of azurerm_storage_account_blob_container.'
  desc 'Testing the singular resource of azurerm_storage_account_blob_container.'

  describe azurerm_storage_account_blob_container(resource_group: resource_group,
                                                  storage_account_name: storage_account,
                                                  blob_container_name: blob_container) do
    it { should exist }
    its('name') { should eq(blob_container) }
  end
end
