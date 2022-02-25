resource_group = attribute('resource_group', default: nil)
iothub_resource_name = attribute('iothub_resource_name', default: nil)
iothub_event_hub_endpoint = attribute('iothub_event_hub_endpoint', default: nil)
consumer_groups = attribute('consumer_groups', default: nil)

control 'azurerm_iothub_event_hub_consumer_groups' do

  impact 1.0
  title 'Testing the plural resource of azurerm_iothub_event_hub_consumer_groups.'
  desc 'Testing the plural resource of azurerm_iothub_event_hub_consumer_groups.'

  azurerm_iothub_event_hub_consumer_groups(resource_group: resource_group,
                                           resource_name: iothub_resource_name,
                                           event_hub_endpoint: iothub_event_hub_endpoint).entries.each do |consumer_group|
    describe consumer_group do
      its('name') { should be_in consumer_groups }
      its('type') { should include 'Microsoft.Devices/IotHubs/EventHubEndpoints/ConsumerGroups' }
    end
  end

  azurerm_iothub_event_hub_consumer_groups(resource_group: resource_group,
                                           resource_name: iothub_resource_name,
                                           event_hub_endpoint: iothub_event_hub_endpoint) do
    its          { should exist }
    its('names') { should include consumer_groups.first }
    its('type')  { should include 'Microsoft.Devices/IotHubs/EventHubEndpoints/ConsumerGroups' }
  end
end
