resource_group = input('resource_group', value: nil)
circuit_name = input('circuitName', value: nil)
location = input('circuitLocation', value: nil)
global_reach_enabled = input('globalReachEnabled', value: false)
allow_global_reach = input('allowGlobalReach', value: false)
service_provider_provisioning_state = input('serviceProviderProvisioningState', value: nil)
gateway_manager_etag = input('gatewayManagerEtag', value: '')
allow_classic_operations = input('allowClassicOperations', value: false)
circuit_provisioning_state = input('circuitProvisioningState', value: nil)

bandwidth_in_mbps = input('bandwidthInMbps', value: nil)
peering_location = input('peeringLocation', value: nil)
service_provider_name = input('serviceProviderName', value: nil)

sku_name = input('sku_name', value: nil)
sku_tier = input('sku_tier', value: nil)
sku_family = input('sku_family', value: nil)

control 'azure_express_route_circuits_resources' do
  describe azure_express_route_circuits_resources(resource_group: resource_group) do
    it { should exist }
    its('names') { should include circuit_name }
    its('locations') { should include location }
    its('types') { should include 'Microsoft.Network/expressRouteCircuits' }
    its('provisioning_states') { should include('Succeeded') }
    its('service_provider_properties_bandwidth_in_mbps') { should include bandwidth_in_mbps }
    its('service_provider_properties_peering_locations') { should include peering_location }
    its('service_provider_properties_names') { should include service_provider_name }
    its('service_provider_provisioning_states') { should include service_provider_provisioning_state }
    its('global_reach_enabled') { should include global_reach_enabled }
    its('allow_global_reach') { should include allow_global_reach }
    its('gateway_manager_etags') { should include gateway_manager_etag }
    its('allow_classic_operations') { should include allow_classic_operations }
    its('circuit_provisioning_states') { should include circuit_provisioning_state }
    its('sku_names') { should include sku_name }
    its('sku_tiers') { should include sku_tier }
    its('sku_families') { should include sku_family }
  end
end
