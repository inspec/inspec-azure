account_name = input(:inspec_adls_account_name, value: '')
filesystem = input(:inspec_adls_fs_name, value: '')

control 'verify settings of all Azure Data Lake Gen2 Paths' do
  describe azure_data_lake_storage_gen2_paths(account_name: account_name, filesystem: filesystem) do
    it { should exist }
    its('names') { should include filesystem }
    its('etags') { should_not be_empty }
  end
end
