resource_group = input('resource_group', value: nil)
circuit_name = input('circuitName', value: nil)
location = input('circuitLocation', value: nil)

control 'azure_express_route_circuit_connections_resource' do
  describe azure_express_route_circuit_connections_resource(resource_group: resource_group, circuit_name: circuit_name) do
    it { should exist }
    its('name') { should eq circuit_name }
    its('type') { should eq 'Microsoft.Network/expressRouteCircuits' }
    its('provisioning_state') { should include('Succeeded') }
    its('location') { should include location }
    its('ipv6_circuit_connection_config_status') { should eq 'Connected' }
    its('circuit_connection_status') { should include 'Connected' }
  end

  describe azure_express_route_circuit_connections_resource(resource_group: resource_group, circuit_name: 'fake') do
    it { should_not exist }
  end

  describe azure_express_route_circuit_connections_resource(resource_group: 'fake', circuit_name: 'cn', peering_name: 'should_not_exist') do
    it { should_not exist }
  end
end
