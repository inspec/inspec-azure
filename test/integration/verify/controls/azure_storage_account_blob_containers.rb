control 'azure_storage_account_blob_containers' do
  impact 1.0
  title 'Testing the plural resource of azure_storage_account_blob_containers.'
  desc 'Testing the plural resource of azure_storage_account_blob_containers.'

  describe azure_storage_account_blob_containers(resource_group: 'rgsoumyo', storage_account_name: 'sasoumyo') do
    its('names') { should include('my_blob_container') }
  end

  describe azure_storage_account_blob_containers(resource_group: 'rgsoumyo', storage_account_name: 'sasoumyo') do
    its('ids') { should include '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/rgsoumyo/providers/Microsoft.Storage/storageAccounts/sasoumyo/blobServices/default/containers/test' }
    its('names') { should include 'test' }
    its('types') { should include 'Microsoft.Storage/storageAccounts/blobServices/containers' }
  end
end
