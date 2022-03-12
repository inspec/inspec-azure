resource_group = input('resource_group', value: nil)
bastion_host_name = input('bastionHostName', value: nil)
df_location = input('bastionHostLocation', value: nil)

control 'azure_bastion_hosts_resource' do

  impact 1.0
  title 'Testing the singular resource of azure_bastion_hosts_resource.'
  desc 'Testing the singular resource of azure_bastion_hosts_resource.'

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
