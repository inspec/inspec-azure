control 'check container groups' do

  impact 1.0
  title 'Testing the plural resource of azure_container_groups.'
  desc 'Testing the plural resource of azure_container_groups.'

  describe azure_container_groups do
    it { should exist }
    its('types') { should include 'Microsoft.ContainerInstance/containerGroups' }
    its('locations') { should include 'eastus' }
    its('restart_policies') { should include 'OnFailure' }
    its('os_types') { should include 'Linux' }
  end

  describe azure_container_groups.where(provisioning_state: 'Succeeded') do
    it { should exist }
  end
end
