resource_group = attribute('resource_group', value: nil)
event_hub_namespace_name = attribute('event_hub_namespace_name', value: nil)
event_hub_name = attribute('event_hub_name', value: nil)

control 'azurerm_event_hub_event_hub' do

  impact 1.0
  title 'Testing the singular resource of azurerm_event_hub_event_hub.'
  desc 'Testing the singular resource of azurerm_event_hub_event_hub.'

  describe azurerm_event_hub_event_hub(resource_group: resource_group, namespace_name: event_hub_namespace_name, event_hub_name: event_hub_name) do
    it          { should exist }
    its('name') { should eq event_hub_name }
    its('type') { should eq 'Microsoft.EventHub/Namespaces/EventHubs' }
  end

  describe azurerm_event_hub_event_hub(resource_group: resource_group, namespace_name: event_hub_namespace_name, event_hub_name: 'fake-event-hub') do
    it { should_not exist }
  end
end
