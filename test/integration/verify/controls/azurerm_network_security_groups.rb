resource_group = attribute('resource_group', default: nil)

control 'azurerm_network_security_groups' do
  describe azurerm_network_security_groups(resource_group: resource_group) do
    it           { should exist }
    its('names') { should be_an(Array) }
  end
end
