resource_group  = attribute('resource_group',  default: nil)
storage_account = attribute('storage_account', default: nil)
blob_container = attribute('storage_account_blob_container', default: nil)

control 'azurerm_storage_account_blob_containers' do
  describe azurerm_storage_account_blob_containers(resource_group: resource_group,
                                                   storage_account_name: storage_account) do
    its('names') { should include(blob_container) }
  end
end
