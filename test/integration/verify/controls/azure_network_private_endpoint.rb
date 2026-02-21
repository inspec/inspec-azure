resource_group = input('resource_group', value: nil)
private_endpoint_name = input('private_endpoint_name', value: '')

control 'azure_network_private_endpoint' do
  title 'Testing the singular resource of azure_network_private_endpoint.'
  desc 'Testing the singular resource of azure_network_private_endpoint.'

  only_if { !private_endpoint_name.empty? }

  describe azure_network_private_endpoint(resource_group: resource_group, name: private_endpoint_name) do
    it { should exist }
    its('name') { should cmp private_endpoint_name }
    its('type') { should eq 'Microsoft.Network/privateEndpoints' }
    its('subnet_id') { should_not be_nil }
    its('network_interface_ids') { should be_an(Array) }
    its('network_interface_ids') { should_not be_empty }
    its('private_link_service_connection_ids') { should be_an(Array) }
    its('private_link_service_connection_ids') { should_not be_empty }
  end

  describe azure_network_private_endpoint(resource_group: resource_group, name: 'fake') do
    it { should_not exist }
  end

  describe azure_network_private_endpoint(resource_group: 'does-not-exist', name: private_endpoint_name) do
    it { should_not exist }
  end
end
