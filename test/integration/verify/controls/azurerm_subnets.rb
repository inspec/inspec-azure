resource_group = attribute('resource_group',  default: nil)
vnet           = attribute('vnet_name',       default: nil)
subnet         = attribute('subnet_name',     default: nil)

control 'azurerm_subnets' do
  describe azurerm_subnets(resource_group: resource_group, vnet: vnet) do
    it           { should exist }
    its('names') { should be_an(Array) }
    its('names') { should include(subnet) }
  end

  describe azurerm_subnets(resource_group: 'fake-group', vnet: vnet) do
    it           { should_not exist }
    its('names') { should_not include('fake') }
  end

  describe azurerm_subnets(resource_group: resource_group, vnet: 'fake') do
    it           { should_not exist }
    its('names') { should_not include('fake') }
  end

  describe azurerm_subnets(resource_group: resource_group, vnet: vnet)
    .where(name: subnet) do
    it { should exist }
  end

end
