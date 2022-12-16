resource_group = input(:resource_group, value: "")
service_bus_namespace_name = input(:service_bus_namespace_name, value: "")
location = input(:location, value: "")

control "test the properties of an Azure Service Bus Namespace" do
  describe azure_service_bus_namespace(resource_group: resource_group, name: service_bus_namespace_name) do
    it { should exist }
    its("sku.name") { should eq "Standard" }
    its("location") { should eq location }
    its("properties.provisioningState") { should eq "Succeeded" }
  end
end
