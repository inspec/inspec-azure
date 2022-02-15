resource_group = input(:resource_group, value: '')

control 'Verify settings of all Azure HPC Storage Targets' do
  describe azure_hpc_storage_targets do
    it { should exist }
    its('name') { should include synapse_ws_name }
    its('locations') { should include location.downcase.gsub("\s", '') }
    its('provisioningStates') { should include 'Succeeded' }
    its('managedResourceGroupNames') { should include resource_group }
    its('sqlAdministratorLogins') { should include 'login' }
  end
end

