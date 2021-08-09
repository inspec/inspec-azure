erc_resource_group = input('resource_group', value: nil)
erc_circuit_name = input('circuitName', value: nil)
erc_location = input('circuitLocation', value: nil)
peering_name = input('peeringName', value: nil)

control 'azure_express_route_circuit_connections_resources' do
  describe azure_express_route_circuit_connections_resources(resource_group: erc_resource_group, circuit_name: erc_circuit_name, peering_name: peering_name) do
    it { should exist }
    its('names') { should include circuitName }
    its('locations') { should include erc_location }
    its('types') { should include 'Microsoft.Network/expressRouteCircuits' }
    its('provisioning_states') { should include('Succeeded') }
    its('circuit_connection_status') { should include('Connected') }
    its('ipv6_circuit_connection_config_status') { should include('Connected') }
  end
end
