resource_group       = attribute('resource_group',              default: nil)
vnet                 = attribute('vnet_name',                   default: nil)
tags                 = attribute('vnet_tags',                   default: nil)
vnet_id              = attribute('vnet_id',                     default: nil)
location             = attribute('vnet_location',               default: nil)
subnets              = attribute('vnet_subnets',                default: nil)
address_space        = attribute('vnet_address_space',          default: nil)
dns_servers          = attribute('vnet_dns_servers',            default: nil)
vnet_peerings        = attribute('vnet_peerings',               default: nil)
enable_ddos          = attribute('vnet_enable_ddos_protection', default: false)
enable_vm_protection = attribute('vnet_enable_vm_protection',   default: false)

control 'azurerm_virtual_network' do
  describe azurerm_virtual_network(resource_group: resource_group, name: vnet) do
    it                                { should exist }
    its('id')                         { should eq vnet_id }
    its('name')                       { should eq vnet }
    its('location')                   { should eq location }
    its('type')                       { should eq 'Microsoft.Network/virtualNetworks' }
    its('tags')                       { should eq tags }
    its('subnets')                    { should eq subnets }
    its('address_space')              { should eq address_space }
    its('dns_servers')                { should eq dns_servers }
    its('vnet_peerings')              { should eq vnet_peerings }
    its('enable_ddos_protection')     { should eq enable_ddos }
    its('enable_vm_protection')       { should eq enable_vm_protection }
  end

  describe azurerm_virtual_network(resource_group: resource_group, name: 'fake') do
    it { should_not exist }
  end

  describe azurerm_virtual_network(resource_group: 'does-not-exist', name: vnet) do
    it { should_not exist }
  end
end
