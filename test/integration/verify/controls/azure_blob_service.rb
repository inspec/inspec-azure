resource_group = input("resource_group", value: "", description: "")
storage_account_blob_service_id = input("storage_account_blob_service_id", value: "", description: "")
storage_account_blob_service_name = input("storage_account_blob_service_name", value: "", description: "")
storage_account_blob_type = input("storage_account_blob_type", value: "", description: "")
storage_account = input("storage_account", value: "", description: "")

control "azure_blob_service" do
  title "Testing the singular resource of azure_blob_service."
  desc "Testing the singular resource of azure_blob_service."

  describe azure_blob_service(resource_group: resource_group, storage_account_name: storage_account) do
    it { should exist }
  end

  describe azure_blob_service(resource_group: resource_group, storage_account_name: storage_account) do
    its("sku.name") { should eq "Standard_RAGRS" }
    its("sku.tier") { should eq "Standard" }

    its("id") { should eq storage_account_blob_service_id }
    its("name") { should eq storage_account_blob_service_name }
    its("type") { should eq storage_account_blob_type }

    its("properties.changeFeed.enabled") { should eq true }

    its("properties.restorePolicy.enabled") { should eq true }
    its("properties.restorePolicy.days") { should eq 6 }
    # its('properties.restorePolicy.minRestoreTime') { should eq Time.parse('2022-09-13T09:34:18.5206216Z') }

    its("properties.containerDeleteRetentionPolicy.enabled") { should eq true }
    its("properties.containerDeleteRetentionPolicy.days") { should eq 7 }

    its("properties.corsRules") { should be_empty }

    its("properties.deleteRetentionPolicy.allowPermanentDelete") { should eq false }
    its("properties.deleteRetentionPolicy.enabled") { should eq true }
    its("properties.deleteRetentionPolicy.days") { should eq 7 }

    its("properties.isVersioningEnabled") { should eq true }
  end
end
