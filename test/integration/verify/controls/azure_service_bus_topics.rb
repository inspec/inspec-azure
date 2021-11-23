resource_group = input(:resource_group, value: '')
service_bus_namespace_name = input(:service_bus_namespace_name, value: '')
control 'test the properties of all Azure Service Bus Topics' do
  describe azure_service_bus_topics(resource_group: resource_group, namespace_name: service_bus_namespace_name) do
    it { should exist }
    its('statuses') { should include 'Active' }
    its('supportOrderings') { should include true }
    its('enableBatchedOperations') { should include true }
    its('maxSizeInMegabytes') { should include 1024 }
  end
end
