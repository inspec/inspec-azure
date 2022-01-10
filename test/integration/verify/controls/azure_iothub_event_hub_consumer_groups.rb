resource_group = attribute('resource_group', default: nil)
iothub_resource_name = attribute('iothub_resource_name', default: nil)
iothub_event_hub_endpoint = attribute('iothub_event_hub_endpoint', default: nil)
consumer_groups = attribute('consumer_groups', default: nil)

control 'azure_iothub_event_hub_consumer_groups' do

  azure_iothub_event_hub_consumer_groups(resource_group: resource_group,
                                           resource_name: iothub_resource_name,
                                           event_hub_endpoint: iothub_event_hub_endpoint).entries.each do |consumer_group|
    describe consumer_group do
      its('name') { should be_in consumer_groups }
      its('type') { should include 'Microsoft.Devices/IotHubs/EventHubEndpoints/ConsumerGroups' }
    end
  end

  azure_iothub_event_hub_consumer_groups(resource_group: resource_group,
                                           resource_name: iothub_resource_name,
                                           event_hub_endpoint: iothub_event_hub_endpoint) do
    its          { should exist }
    its('names') { should include consumer_groups.first }
    its('type')  { should include 'Microsoft.Devices/IotHubs/EventHubEndpoints/ConsumerGroups' }
  end
end
