resource_group = input("resource_group", value: nil)
circuit_name = input("circuitName", value: nil)
location = input("circuitLocation", value: nil)
global_reach_enabled = input("globalReachEnabled", value: false)
allow_global_reach = input("allowGlobalReach", value: false)
service_provider_provisioning_state = input("serviceProviderProvisioningState", value: nil)
gateway_manager_etag = input("gatewayManagerEtag", value: "")
allow_classic_operations = input("allowClassicOperations", value: false)
circuit_provisioning_state = input("circuitProvisioningState", value: nil)

bandwidth_in_mbps = input("bandwidthInMbps", value: nil)
peering_location = input("peeringLocation", value: nil)
service_provider_name = input("serviceProviderName", value: nil)

sku_name = input("sku_name", value: nil)
sku_tier = input("sku_tier", value: nil)
sku_family = input("sku_family", value: nil)

control "azure_express_route_circuit" do

  title "Testing the singular resource of azure_express_route_circuit."
  desc "Testing the singular resource of azure_express_route_circuit."

  describe azure_express_route_circuit(resource_group: resource_group, circuit_name: circuit_name) do
    it { should exist }
    its("name") { should eq circuit_name }
    its("type") { should eq "Microsoft.Network/expressRouteCircuits" }
    its("provisioning_state") { should include("Succeeded") }
    its("location") { should include location }
    its("service_provider_properties_bandwidth_in_mbps") { should eq bandwidth_in_mbps }
    its("service_provider_properties_peering_location") { should include peering_location }
    its("service_provider_properties_name") { should include service_provider_name }
    its("service_provider_provisioning_state") { should eq service_provider_provisioning_state }
    its("global_reach_enabled") { should eq global_reach_enabled }
    its("allow_global_reach") { should eq allow_global_reach }
    its("gateway_manager_etag") { should include gateway_manager_etag }
    its("allow_classic_operations") { should eq allow_classic_operations }
    its("circuit_provisioning_state") { should include circuit_provisioning_state }
    its("sku_name") { should include sku_name }
    its("sku_tier") { should include sku_tier }
    its("sku_family") { should include sku_family }
  end

  describe azure_express_route_circuit(resource_group: resource_group, circuit_name: "fake") do
    it { should_not exist }
  end

  describe azure_express_route_circuit(resource_group: "fake", circuit_name: circuit_name) do
    it { should_not exist }
  end
end
