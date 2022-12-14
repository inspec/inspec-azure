rg = input(:resource_group, value: "")
location = input(:location, value: "")

control "Verify settings of all Azure Virtual Network Gateway Connections" do

  title "Testing the plural resource of azure_virtual_network_gateway_connections."
  desc "Testing the plural resource of azure_virtual_network_gateway_connections."

  describe azure_virtual_network_gateway_connections(resource_group: rg) do
    it { should exist }
    its("names") { should include "test" }
    its("locations") { should include location }
    its("provisioningStates") { should include "Succeeded" }
    its("connectionTypes") { should include "Vnet2Vnet" }
    its("connectionProtocols") { should include "IKEv2" }
    its("ipsecPolicies") { should_not be_empty }
  end
end
