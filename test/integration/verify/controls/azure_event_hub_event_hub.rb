resource_group = attribute('resource_group', default: nil)
event_hub_namespace_name = attribute('event_hub_namespace_name', default: nil)
event_hub_name = attribute('event_hub_name', default: nil)

control 'azure_event_hub_event_hub' do

  describe azure_event_hub_event_hub(resource_group: resource_group, namespace_name: event_hub_namespace_name, event_hub_name: event_hub_name) do
    it          { should exist }
    its('name') { should eq event_hub_name }
    its('type') { should eq 'Microsoft.EventHub/Namespaces/EventHubs' }
  end

  describe azure_event_hub_event_hub(resource_group: resource_group, namespace_name: event_hub_namespace_name, event_hub_name: 'fake-event-hub') do
    it { should_not exist }
  end
end
