resource_group = attribute('resource_group', value: nil)
iothub_resource_name = attribute('iothub_resource_name', value: nil)
iothub_event_hub_endpoint = attribute('iothub_event_hub_endpoint', value: nil)
consumer_group = attribute('consumer_group', value: nil)

control 'azurerm_iothub_event_hub_consumer_group' do

  impact 1.0
  title 'Testing the singular resource of azurerm_iothub_event_hub_consumer_group.'
  desc 'Testing the singular resource of azurerm_iothub_event_hub_consumer_group.'

  describe azurerm_iothub_event_hub_consumer_group(resource_group: resource_group, resource_name: iothub_resource_name, event_hub_endpoint: iothub_event_hub_endpoint, consumer_group: consumer_group) do
    it          { should exist }
    its('name') { should eq consumer_group }
    its('type') { should eq 'Microsoft.Devices/IotHubs/EventHubEndpoints/ConsumerGroups' }
  end

  describe azurerm_iothub_event_hub_consumer_group(resource_group: resource_group, resource_name: iothub_resource_name, event_hub_endpoint: iothub_event_hub_endpoint, consumer_group: 'invalid-consumer-group') do
    it { should_not exist }
  end
end
