resource_group = input('resource_group', value: nil)
bastion_host_name = input('bastionHostName', value: nil)
df_location = input('df_location', value: nil)

control 'azure_bastion_hosts_resource' do

  describe azure_bastion_hosts_resource(resource_group: resource_group, name: bastion_host_name) do
    it { should exist }
    its('name') { should eq bastion_host_name }
    its('type') { should eq 'Microsoft.Network/bastionHosts' }
    its('provisioning_state') { should include('Succeeded') }
    its('location') { should include df_location }
  end

  describe azure_bastion_hosts_resource(resource_group: resource_group, name: 'fake') do
    it { should_not exist }
  end

  describe azure_bastion_hosts_resource(resource_group: 'fake', name: bastion_host_name) do
    it { should_not exist }
  end
end
