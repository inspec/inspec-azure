account_name = input(:inspec_adls_account_name, value: '')
filesystem = input(:inspec_adls_fs_name, value: '')

control 'verify settings of Azure Data Lake Gen2 Filesystem' do

  impact 1.0
  title 'Testing the singular resource of azure_data_lake_storage_gen2_filesystem.'
  desc 'Testing the singular resource of azure_data_lake_storage_gen2_filesystem.'

  describe azure_data_lake_storage_gen2_filesystem(account_name: account_name, name: filesystem) do
    it { should exist }
    its('x_ms_namespace_enabled') { should eq 'false' }
    its('x_ms_default_encryption_scope') { should eq '$account-encryption-key' }
    its('x_ms_deny_encryption_scope_override') { should eq 'false' }
  end
end
