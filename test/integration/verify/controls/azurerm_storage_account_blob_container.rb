resource_group = attribute('resource_group', default: nil)
storage_account = attribute('storage_account', default: nil)
blob_container = attribute('storage_account_blob_container', default: nil)

control 'azurerm_storage_account_blob_container' do
  describe azurerm_storage_account_blob_container(resource_group: resource_group,
                                                  storage_account_name: storage_account,
                                                  blob_container_name: blob_container) do
    it { should exist }
    its('name') { should eq(blob_container) }
  end
end
