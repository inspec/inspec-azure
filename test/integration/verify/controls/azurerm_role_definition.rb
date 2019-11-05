contributor_name = input('contributor_role_name', value: nil)

control 'azurerm_role_definition' do
  describe azurerm_role_definition(name: contributor_name) do
    it                         { should exist }
    its('permissions_allowed') { should include '*' }
  end
end
