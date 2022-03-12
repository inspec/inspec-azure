resource_group = input(:resource_group, value: '')
service_bus_namespace_name = input(:service_bus_namespace_name, value: '')
service_bus_subscription_name = input(:service_bus_subscription_name, value: '')
service_bus_topic_name = input(:service_bus_topic_name, value: '')

control 'Verify the settings for an Azure Service Bus Subscription' do
  describe azure_service_bus_subscription(resource_group: resource_group, namespace_name: service_bus_namespace_name, topic_name: service_bus_topic_name, name: service_bus_subscription_name) do
    it { should exist }
    its('type') { should eq 'Microsoft.ServiceBus/Namespaces/Topics/Subscriptions/Rules' }
    its('properties.lockDuration') { should eq 'PT1M' }
    its('properties.status') { should eq 'Active' }
  end
end
