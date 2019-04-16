resource_group = attribute('resource_group', default: nil)
namespace_name = attribute('namespace_name', default: nil)
event_hub_endpoint = attribute('event_hub_endpoint', default: nil)
authorization_rule = attribute('authorization_rule', default: nil)

control 'azurerm_event_hub_authorization_rule' do

  describe azurerm_event_hub_authorization_rule(resource_group: resource_group, namespace_name: namespace_name, event_hub_endpoint: event_hub_endpoint, authorization_rule: authorization_rule) do
    it          { should exist }
    its('name') { should eq authorization_rule }
    its('type') { should eq 'Microsoft.EventHub/Namespaces/EventHubs/AuthorizationRules' }
  end

  describe azurerm_event_hub_authorization_rule(resource_group: resource_group, namespace_name: 'fake-ns', event_hub_endpoint: 'fake-event-hub') do
    it { should_not exist }
  end
end
