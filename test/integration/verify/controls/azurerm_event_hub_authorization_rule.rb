resource_group = attribute("resource_group", default: nil)
event_hub_namespace_name = attribute("event_hub_namespace_name", default: nil)
event_hub_endpoint = attribute("event_hub_endpoint", default: nil)
event_hub_authorization_rule = attribute("event_hub_authorization_rule", default: nil)

control "azurerm_event_hub_authorization_rule" do

  describe azurerm_event_hub_authorization_rule(resource_group: resource_group, namespace_name: event_hub_namespace_name, event_hub_endpoint: event_hub_endpoint, authorization_rule: event_hub_authorization_rule) do
    it          { should exist }
    its("name") { should eq event_hub_authorization_rule }
    its("type") { should eq "Microsoft.EventHub/Namespaces/EventHubs/AuthorizationRules" }
  end

  describe azurerm_event_hub_authorization_rule(resource_group: resource_group, namespace_name: "fake-ns", event_hub_endpoint: "fake-event-hub") do
    it { should_not exist }
  end
end
