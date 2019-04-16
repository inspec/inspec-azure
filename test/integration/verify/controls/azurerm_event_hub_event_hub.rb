resource_group = attribute('resource_group', default: nil)
namespace_name = attribute('namespace_name', default: nil)
event_hub_name = attribute('event_hub_name', default: nil)

control 'azurerm_event_hub_event_hub' do

  describe azurerm_event_hub_event_hub(resource_group: resource_group, namespace_name: namespace_name, event_hub_name: event_hub_name) do
    it          { should exist }
    its('name') { should eq event_hub_name }
    its('type') { should eq 'Microsoft.EventHub/Namespaces/EventHubs' }
  end

  describe azurerm_event_hub_event_hub(resource_group: resource_group, namespace_name: 'fake-ns', event_hub_name: 'fake-event-hub') do
    it { should_not exist }
  end
end
