resource_group = attribute('resource_group', default: nil)
iothub_resource_name = attribute('iothub_resource_name', default: nil)
iothub_event_hub_endpoint = attribute('iothub_event_hub_endpoint', default: nil)
consumer_group = attribute('consumer_group', default: nil)

control 'azurerm_iothub_event_hub_consumer_group' do

  describe azurerm_iothub_event_hub_consumer_group(resource_group: resource_group, resource_name: iothub_resource_name, event_hub_endpoint: iothub_event_hub_endpoint, consumer_group: consumer_group) do
    it          { should exist }
    its('name') { should eq consumer_group }
    its('type') { should eq 'Microsoft.Devices/IotHubs/EventHubEndpoints/ConsumerGroups' }
  end

  describe azurerm_iothub_event_hub_consumer_group(resource_group: resource_group, resource_name: 'fake', event_hub_endpoint: 'i-do-not-exist', consumer_group: 'invalid-consumer-group') do
    it { should_not exist }
  end
end
