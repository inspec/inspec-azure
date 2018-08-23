resource_group  = attribute('resource_group',        default: nil)
name            = attribute('subnet_name',           default: nil)
id              = attribute('subnet_id',             default: nil)
vnet            = attribute('vnet_name',             default: nil)
address_prefix  = attribute('subnet_address_prefix', default: nil)
nsg             = attribute('subnet_nsg',            default: nil)

control 'azurerm_subnet' do
  describe azurerm_subnet(resource_group: resource_group, vnet: vnet, name: name) do
    it                    { should exist }
    its('id')             { should eq id }
    its('name')           { should eq name }
    its('type')           { should eq 'Microsoft.Network/virtualNetworks/subnets' }
    its('address_prefix') { should eq address_prefix }
    its('nsg')            { should eq nsg }
  end

  describe azurerm_subnet(resource_group: resource_group, vnet: vnet, name: 'fake') do
    it { should_not exist }
  end

  describe azurerm_subnet(resource_group: 'does-not-exist', vnet: vnet, name: name) do
    it { should_not exist }
  end
end
