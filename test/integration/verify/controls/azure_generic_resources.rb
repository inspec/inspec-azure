resource_group = input('resource_group', value: nil)
vm_names = input('vm_names', value: [])
win_location = input('windows_vm_location', value: nil)
win_tags = input('windows_vm_tags', value: nil)

control 'azure_generic_resources' do
  describe azure_generic_resources do
    it { should exist }
  end

  # Loop through resources via singular resource.
  azure_generic_resources(resource_group: resource_group).ids.each do |id|
    describe azure_generic_resource(resource_id: id) do
      its('resource_group') { should cmp resource_group }
    end
  end

  describe azure_generic_resources(resource_group: resource_group) do
    its('names') { should include(vm_names.first) }
    its('tags') { should include(win_tags) }
    its('locations') { should include(win_location) }
    its('types') { should include('Microsoft.Compute/virtualMachines') }
    its('provisioning_states') { should include('Succeeded') }
  end

  describe azure_generic_resources(resource_group: 'fake-group') do
    it { should_not exist }
  end

  # Test substring_of name and resource_group
  describe azure_generic_resources(substring_of_resource_group: resource_group[0..-2]) do
    it { should exist }
  end

  azure_generic_resources(substring_of_name: vm_names[-10..-1]).names.each do |name|
    describe azure_generic_resource(resource_group: resource_group, name: name)
    it { should exist }
    its('name') { should cmp name }
  end
end
