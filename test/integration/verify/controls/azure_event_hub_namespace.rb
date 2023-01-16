resource_group = input("resource_group", value: nil)
event_hub_namespace_name = input("event_hub_namespace_name", value: nil)

control "azure_event_hub_namespace" do
  title "Testing the singular resource of azure_event_hub_namespace."
  desc "Testing the singular resource of azure_event_hub_namespace."

  describe azure_event_hub_namespace(resource_group: resource_group, namespace_name: event_hub_namespace_name) do
    it          { should exist }
    its("name") { should eq event_hub_namespace_name }
    its("type") { should eq "Microsoft.EventHub/Namespaces" }
  end

  describe azure_event_hub_namespace(resource_group: resource_group, namespace_name: "fake") do
    it { should_not exist }
  end
end
