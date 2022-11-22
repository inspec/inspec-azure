resource_group = input('resource_group', value: '', description: '')
storage_account_blob_service_id = input('storage_account_blob_service_id', value: '', description: '')
storage_account_blob_service_name = input('storage_account_blob_service_name', value: '', description: '')
storage_account_blob_type = input('storage_account_blob_type', value: '', description: '')
storage_account = input('storage_account', value: '', description: '')

control 'azure_blob_services' do
  impact 1.0
  title 'Testing the plural resource of azure_blob_services.'
  desc 'Testing the plural resource of azure_blob_services.'

  describe azure_blob_services(resource_group: resource_group, storage_account_name: storage_account) do
    it { should exist }
  end

  describe azure_blob_services(resource_group: resource_group, storage_account_name: storage_account) do
    its('skus') { should_not be_empty }
    its('ids') { should include(storage_account_blob_service_id) }
    its('names') { should include(storage_account_blob_service_name) }
    its('types') { should include(storage_account_blob_type) }
    its('properties') { should_not be_empty }
  end
end
