resource_group = input("resource_group", value: nil)
iothub_resource_name = input("iothub_resource_name", value: nil)
iothub_event_hub_endpoint = input("iothub_event_hub_endpoint", value: nil)
consumer_group = input("consumer_group", value: nil)

control "azure_iothub_event_hub_consumer_group" do
  title "Testing the singular resource of azure_iothub_event_hub_consumer_group."
  desc "Testing the singular resource of azure_iothub_event_hub_consumer_group."

  describe azure_iothub_event_hub_consumer_group(resource_group: resource_group, resource_name: iothub_resource_name, event_hub_endpoint: iothub_event_hub_endpoint, consumer_group: consumer_group) do
    it          { should exist }
    its("name") { should eq consumer_group }
    its("type") { should eq "Microsoft.Devices/IotHubs/EventHubEndpoints/ConsumerGroups" }
  end

  describe azure_iothub_event_hub_consumer_group(resource_group: resource_group, resource_name: iothub_resource_name, event_hub_endpoint: iothub_event_hub_endpoint, consumer_group: "invalid-consumer-group") do
    it { should_not exist }
  end
end
