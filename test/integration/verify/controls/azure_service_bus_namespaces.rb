resource_group = input(:resource_group, value: "")
service_bus_namespace_name = input(:service_bus_namespace_name, value: "")
location = input(:location, value: "")

control "test the properties of all Azure Service Bus Namespaces" do
  describe azure_service_bus_namespaces(resource_group: resource_group) do
    it { should exist }
    its("names") { should include service_bus_namespace_name }
    its("sku_names") { should include "Standard" }
    its("locations") { should include location }
    its("types") { should include "Microsoft.ServiceBus/Namespaces" }
    its("provisioningStates") { should include "Succeeded" }
  end
end
