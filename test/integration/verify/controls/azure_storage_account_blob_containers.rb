resource_group  = input("resource_group",  value: nil)
storage_account = input("storage_account", value: nil)
blob_container = input("storage_account_blob_container", value: nil)

control "azure_storage_account_blob_containers" do
  title "Testing the plural resource of azure_storage_account_blob_containers."
  desc "Testing the plural resource of azure_storage_account_blob_containers."

  describe azure_storage_account_blob_containers(resource_group: resource_group, storage_account_name: storage_account) do
    its("names") { should include(blob_container) }
  end
end
