resource_group = input(:resource_group, value: '')
container_group_name = input(:inspec_container_group_name, value: '')

control 'check container group properties' do
  describe azure_container_group(resource_group: resource_group, name: container_group_name) do
    it { should exist }
    its('location') { should eq 'eastus' }
    its('properties.ipAddress.type') { should eq 'Public' }
    its('properties.containers.first.properties.resources.requests.item') { should cmp({ memoryInGB: 0.5, cpu: 0.5 }) }
  end
end
