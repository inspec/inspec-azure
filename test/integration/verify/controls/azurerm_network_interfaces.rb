resource_group = attribute('resource_group', default: nil)
nic_name = attribute('windows_vm_nic_name', default: nil)

control 'azurerm_network_interfaces' do

  describe azurerm_network_interfaces(resource_group: resource_group) do
    it           { should exist }
    its('names') { should include nic_name }
  end
end
