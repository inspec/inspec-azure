resource_group = input('resource_group', value: nil)
storage_account = input('storage_account', value: nil)

control 'azure availability status' do

  title 'Testing the singular resource of azure_resource_health_availability_status.'
  desc 'Testing the singular resource of azure_resource_health_availability_status.'

  describe azure_resource_health_availability_status(resource_group: resource_group, resource_type: 'microsoft.storage/storageaccounts', name: storage_account) do
    it { should exist }
    its('location') { should eq 'ukwest' }
    its('properties.availabilityState') { should eq 'Available' }
    its('properties.reasonChronicity') { should eq 'Persistent' }
  end
end
