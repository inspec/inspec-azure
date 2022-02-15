resource_group = input(:resource_group, value: '')
location = input(:location, value: '')

control 'Verify settings of all Azure HPC Storage Target' do
  describe azure_hpc_storage_target(resource_group: resource_group, name: synapse_ws_name) do
    it { should exist }
    its('name') { should eq synapse_ws_name }
    its('location') { should eq location.downcase.gsub("\s", '') }
    its('properties.provisioningState') { should eq 'Succeeded' }
    its('properties.managedResourceGroupName') { should eq resource_group }
    its('properties.sqlAdministratorLogin') { should eq 'login' }
  end
end
