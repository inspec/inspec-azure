contributor_name = input('contributor_role_name', value: nil)

control 'azurerm_role_definition' do
  describe azurerm_role_definition(name: contributor_name) do
    it { should exist }
    its('permissions_allowed') { should include '*' }
    its('role_name') { should cmp 'Contributor' }
    its('assignable_scopes') { should cmp '/' }
    its('permissions_allowed') { should cmp '*' }
    its('permissions_not_allowed') { should include 'Microsoft.Authorization/*/Delete' }
  end
end
