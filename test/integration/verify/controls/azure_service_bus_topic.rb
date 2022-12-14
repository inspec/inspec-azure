resource_group = input(:resource_group, value: "")
service_bus_namespace_name = input(:service_bus_namespace_name, value: "")

control "test the properties of all Azure Service Bus Topic" do
  describe azure_service_bus_topic(resource_group: resource_group, namespace_name: service_bus_namespace_name, name: "inspec-topic") do
    it { should exist }
    its("properties.status") { should eq "Active" }
    its("properties.supportOrdering") { should eq true }
    its("properties.enableBatchedOperations") { should eq true }
    its("properties.maxSizeInMegabytes") { should eq 1024 }
  end
end
