account_name = input(:inspec_adls_account_name, value: "")
filesystem = input(:inspec_adls_fs_name, value: "")
pathname = input(:inspec_adls_fs_path, value: "")

control "verify settings of Azure Data Lake Gen2 Filesystem Path" do
  describe azure_data_lake_storage_gen2_path(account_name: account_name, filesystem: filesystem, name: pathname) do
    it { should exist }
    its("x_ms_resource_type") { should eq "file" }
    its("x_ms_lease_state") { should eq "available" }
    its("x_ms_lease_status") { should eq "unlocked" }
    its("x_ms_server_encrypted") { should eq "true" }
  end
end
