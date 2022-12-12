resource_group = input('resource_group', value: nil)
storage_account = input('storage_account', value: nil)

control 'azure_storage_account' do

  title 'Testing the singular resource of azure_storage_account.'
  desc 'Testing the singular resource of azure_storage_account.'

  describe azure_storage_account(resource_group: resource_group, name: storage_account) do
    it { should exist }
    it { should have_encryption_enabled }
    it { should_not have_recently_generated_access_key }
    its('properties') { should have_attributes(supportsHttpsTrafficOnly: true) }
    its('queues.enumeration_results.service_endpoint') { should include(storage_account) }
  end
end
