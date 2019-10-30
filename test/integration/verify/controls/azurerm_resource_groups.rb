resource_group = attribute('resource_group', value: nil)

control 'azurerm_resource_groups' do
  describe azurerm_resource_groups do
    it           { should exist }
    its('names') { should include(resource_group) }
  end
end
