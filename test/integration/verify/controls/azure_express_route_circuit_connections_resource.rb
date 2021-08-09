resource_group = input('resource_group', value: nil)
circuit_name = input('circuitName', value: nil)
location = input('circuitLocation', value: nil)
peering_name = input('peeringName', value: nil)
connection_name = input('connectionName', value: nil)

control 'azure_express_route_circuit_connections_resource' do
  describe azure_express_route_circuit_connections_resource(resource_group: resource_group, circuit_name: circuit_name,
                                                            peering_name: peering_name, connection_name: connection_name) do
    it { should exist }
    its('name') { should eq circuit_name }
    its('type') { should eq 'Microsoft.Network/expressRouteCircuits' }
    its('provisioning_state') { should include('Succeeded') }
    its('location') { should include location }
    its('ipv6_circuit_connection_config_status') { should eq 'Connected' }
    its('circuit_connection_status') { should include 'Connected' }
  end

  describe azure_express_route_circuit_connections_resource(resource_group: resource_group, circuit_name: circuit_name,
                                                            peering_name: peering_name, connection_name: connection_name) do
    it { should_not exist }
  end

  describe azure_express_route_circuit_connections_resource(resource_group: resource_group, circuit_name: circuit_name,
                                                            peering_name: peering_name, connection_name: 'does_not_exist') do
    it { should_not exist }
  end
end
