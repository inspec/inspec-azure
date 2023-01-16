resource_group = input("resource_group", value: nil)
event_hub_namespace_name = input("event_hub_namespace_name", value: nil)
event_hub_endpoint = input("event_hub_endpoint", value: nil)
event_hub_authorization_rule = input("event_hub_authorization_rule", value: nil)

control "azure_event_hub_authorization_rule" do
  title "Testing the singular resource of azure_event_hub_authorization_rule."
  desc "Testing the singular resource of azure_event_hub_authorization_rule."

  describe azure_event_hub_authorization_rule(resource_group: resource_group, namespace_name: event_hub_namespace_name, event_hub_endpoint: event_hub_endpoint, authorization_rule: event_hub_authorization_rule) do
    it          { should exist }
    its("name") { should eq event_hub_authorization_rule }
    its("type") { should eq "Microsoft.EventHub/Namespaces/EventHubs/AuthorizationRules" }
  end

  describe azure_event_hub_authorization_rule(resource_group: resource_group, namespace_name: event_hub_namespace_name, event_hub_endpoint: event_hub_endpoint, authorization_rule: "fake") do
    it { should_not exist }
  end
end
