resource_group = input('resource_group', value: nil)
private_endpoint_name = input('private_endpoint_name', value: '')

control 'azure_network_private_endpoints' do
  title 'Testing the plural resource of azure_network_private_endpoints.'
  desc 'Testing the plural resource of azure_network_private_endpoints.'

  only_if { !private_endpoint_name.empty? }

  describe azure_network_private_endpoints(resource_group: resource_group) do
    it { should exist }
    its('names') { should include(private_endpoint_name) }
    its('types') { should include('Microsoft.Network/privateEndpoints') }
  end

  describe azure_network_private_endpoints(resource_group: 'fake-group') do
    it { should_not exist }
    its('names') { should_not include('fake') }
  end

  describe azure_network_private_endpoints(resource_group: resource_group).where(name: private_endpoint_name) do
    it { should exist }
  end
end
