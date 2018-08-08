resource_group = attribute('resource_group',  default: nil)
vnet           = attribute('vnet_name',       default: nil)

control 'azurerm_virtual_networks' do
  describe azurerm_virtual_networks(resource_group: resource_group) do
    it                              { should exist }
    its('names')                    { should be_an(Array) }
    its('names')                    { should include(vnet) }
  end

  describe azurerm_virtual_networks(resource_group: 'fake-group') do
    it              { should_not exist }
    its('names')    { should_not include('fake') }
  end

  describe azurerm_virtual_networks(resource_group: resource_group)
    .where(name: vnet) do
    it { should exist }
  end
end
