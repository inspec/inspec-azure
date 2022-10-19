control 'azure_storage_account_blob_container' do
  impact 1.0
  title 'Testing the singular resource of azure_storage_account_blob_container.'
  desc 'Testing the singular resource of azure_storage_account_blob_container.'

  describe azure_storage_account_blob_container(resource_group: 'rgsoumyo', storage_account_name: 'sasoumyo', name: 'test') do
    it { should exist }
  end

  describe azure_storage_account_blob_container(resource_group: 'rgsoumyo', storage_account_name: 'sasoumyo', name: 'test') do
    its('id') { should eq '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/rgsoumyo/providers/Microsoft.Storage/storageAccounts/sasoumyo/blobServices/default/containers/test' }
    its('name') { should eq 'test' }
    its('type') { should eq 'Microsoft.Storage/storageAccounts/blobServices/containers' }
  end
end
