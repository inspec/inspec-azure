resource_group = input('resource_group', value: nil)

control 'azurerm_resource_groups' do
  describe azurerm_resource_groups do
    it           { should exist }
    its('names') { should include(resource_group) }
    its('tags')  { should include({}) }
  end
end
