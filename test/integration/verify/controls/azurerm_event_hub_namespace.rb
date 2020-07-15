resource_group = attribute("resource_group", default: nil)
event_hub_namespace_name = attribute("event_hub_namespace_name", default: nil)

control "azurerm_event_hub_namespace" do

  describe azurerm_event_hub_namespace(resource_group: resource_group, namespace_name: event_hub_namespace_name) do
    it          { should exist }
    its("name") { should eq event_hub_namespace_name }
    its("type") { should eq "Microsoft.EventHub/Namespaces" }
  end

  describe azurerm_event_hub_namespace(resource_group: resource_group, namespace_name: "fake") do
    it { should_not exist }
  end
end
