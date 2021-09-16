resource_group  = input('resource_group',                         value: nil)
name            = input('virtual_network_peering_name',           value: nil)
id              = input('virtual_network_peering_id',             value: nil)
vnet            = input('vnet_name',                              value: nil)

control 'azurerm_virtual_network_peering' do
  describe azurerm_virtual_network_peering(resource_group: resource_group, vnet: vnet, name: name) do
    it                    { should exist }
    its('id')             { should eq id }
    its('name')           { should eq name }
    its('peering_state')  { should eq 'Connected' }
  end

  describe azurerm_virtual_network_peering(resource_group: resource_group, vnet: vnet, name: 'fake') do
    it { should_not exist }
  end

  describe azurerm_virtual_network_peering(resource_group: 'does-not-exist', vnet: vnet, name: name) do
    it { should_not exist }
  end
end
