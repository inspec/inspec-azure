resource_group = attribute('resource_group', default: nil)
namespace_name = attribute('namespace_name', default: nil)

control 'azurerm_event_hub_namespace' do

  describe azurerm_event_hub_namespace(resource_group: resource_group, namespace_name: namespace_name) do
    it          { should exist }
    its('name') { should eq namespace_name }
    its('type') { should eq 'Microsoft.EventHub/Namespaces' }
  end

  describe azurerm_event_hub_namespace(resource_group: resource_group, namespace_name: 'fake') do
    it { should_not exist }
  end
end
