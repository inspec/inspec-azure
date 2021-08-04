control 'check container groups' do
  describe azure_container_groups do
    it { should exist }
    its('types') { should include 'Microsoft.ContainerInstance/containerGroups' }
    its('locations') { should include 'eastus' }
    its('restart_policies') { should include 'OnFailure' }
    its('os_types') { should include 'Linux' }
  end
end

control 'check all container groups that have been provisioned' do
  describe azure_container_groups.where(provisioning_state: 'Succeeded') do
    it { should exist }
  end
end
