resource_group       = input('resource_group',              value: nil)
vnet                 = input('vnet_name',                   value: nil)
tags                 = input('vnet_tags',                   value: nil)
vnet_id              = input('vnet_id',                     value: nil)
location             = input('vnet_location',               value: nil)
subnets              = input('vnet_subnets',                value: nil)
address_space        = input('vnet_address_space',          value: nil)
dns_servers          = input('vnet_dns_servers',            value: nil)
vnet_peerings        = input('vnet_peerings',               value: nil)
enable_ddos          = input('vnet_enable_ddos_protection', value: false)
enable_vm_protection = input('vnet_enable_vm_protection',   value: false)

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

control 'azure_virtual_network' do
  impact 1.0
  title 'Ensure that azure_virtual_network supports `resource_id` as a parameter.'

  describe azure_virtual_network(resource_id: vnet_id) do
    its('name') { should cmp vnet }
  end
end
