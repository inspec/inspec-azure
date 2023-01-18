resource_group = input("resource_group", value: nil)
iothub_resource_name = input("iothub_resource_name", value: nil)
iothub_event_hub_endpoint = input("iothub_event_hub_endpoint", value: nil)
consumer_groups = input("consumer_groups", value: nil)

control "azure_iothub_event_hub_consumer_groups" do
  title "Testing the plural resource of azure_iothub_event_hub_consumer_groups."
  desc "Testing the plural resource of azure_iothub_event_hub_consumer_groups."

  azure_iothub_event_hub_consumer_groups(resource_group: resource_group, resource_name: iothub_resource_name, event_hub_endpoint: iothub_event_hub_endpoint).entries.each do |consumer_group|
    describe consumer_group do
      its("name") { should be_in consumer_groups }
      its("type") { should include "Microsoft.Devices/IotHubs/EventHubEndpoints/ConsumerGroups" }
    end
  end

  describe azure_iothub_event_hub_consumer_groups(resource_group: resource_group, resource_name: iothub_resource_name, event_hub_endpoint: iothub_event_hub_endpoint) do
    its { should exist }
    its("names") { should include consumer_groups.first }
    its("type")  { should include "Microsoft.Devices/IotHubs/EventHubEndpoints/ConsumerGroups" }
  end
end
