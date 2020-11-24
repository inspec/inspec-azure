contributor_name = input('contributor_role_name', value: nil)

control 'azurerm_role_definitions' do
  describe azurerm_role_definitions.where(name: contributor_name) do
    its('names') { should include contributor_name }
    its('properties.first') { should have_attributes(roleName: 'Contributor') }
    its('properties.first.permissions.first') { should have_attributes(actions: ['*']) }
  end
end
