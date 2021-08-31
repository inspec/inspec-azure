resource_group = input('resource_group', value: nil)
bastion_host_name = input('bastionHostName', value: nil)
df_location = input('bastionHostLocation', value: nil)

control 'azure_bastion_hosts_resources' do
  describe azure_bastion_hosts_resources(resource_group: resource_group) do
    it { should exist }
    its('names') { should include bastion_host_name }
    its('locations') { should include df_location }
    its('types') { should include 'Microsoft.Network/bastionHosts' }
    its('provisioning_states') { should include('Succeeded') }
  end
end
