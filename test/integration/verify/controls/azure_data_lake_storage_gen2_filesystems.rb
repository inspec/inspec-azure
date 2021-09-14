account_name = input(:inspec_adls_account_name, value: '')
filesystem = input(:inspec_adls_fs_name, value: '')

control 'verify settings of all Azure Data Lake Gen2 Filesystems' do
  describe azure_data_lake_storage_gen2_filesystems(account_name: account_name) do
    it { should exist }
    its('names') { should include filesystem }
    its('etags') { should_not be_empty }
    its('DefaultEncryptionScopes') { should include '$account-encryption-key' }
  end
end
