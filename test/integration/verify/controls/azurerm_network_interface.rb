resource_group = attribute('resource_group', value: nil)
nic_name = attribute('windows_vm_nic_name', value: nil)

control 'azurerm_network_interface' do

  impact 1.0
  title 'Testing the singular resource of azurerm_network_interface.'
  desc 'Testing the singular resource of azurerm_network_interface.'

  describe azurerm_network_interface(resource_group: resource_group, name: nic_name) do
    it                { should exist }
    its('id')         { should_not be_nil }
    its('name')       { should eq nic_name }
    its('location')   { should_not be_nil }
    its('type')       { should eq 'Microsoft.Network/networkInterfaces' }
    it { should have_private_address_ip }
  end
end
