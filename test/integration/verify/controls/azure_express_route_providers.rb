express_route_name = input("express_route_name", value: nil)

control "azure_express_route_providers" do

  title "Testing the plural resource of azure_express_route_providers."
  desc "Testing the plural resource of azure_express_route_providers."

  describe azure_express_route_providers do
    its("names") { should include express_route_name }
    its("types") { should include "Microsoft.Network/expressRouteServiceProviders" }
    its("provisioning_states") { should include("Succeeded") }
  end
end
