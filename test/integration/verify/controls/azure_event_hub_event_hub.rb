resource_group = input("resource_group", value: nil)
event_hub_namespace_name = input("event_hub_namespace_name", value: nil)
event_hub_name = input("event_hub_name", value: nil)

control "azure_event_hub_event_hub" do
  title "Testing the singular resource of azure_event_hub_event_hub."
  desc "Testing the singular resource of azure_event_hub_event_hub."

  describe azure_event_hub_event_hub(resource_group: resource_group, namespace_name: event_hub_namespace_name, event_hub_name: event_hub_name) do
    it          { should exist }
    its("name") { should eq event_hub_name }
    its("type") { should eq "Microsoft.EventHub/Namespaces/EventHubs" }
  end

  describe azure_event_hub_event_hub(resource_group: resource_group, namespace_name: event_hub_namespace_name, event_hub_name: "fake-event-hub") do
    it { should_not exist }
  end
end
