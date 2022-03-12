tenant_id = input('tenant_id', value: nil)
parent_mg = input('parent_mg', value: nil)
child1_mg = input('child1_mg', value: nil)
child2_mg = input('child2_mg', value: nil)
parent_dn = input('parent_dn', value: nil)

control 'azurerm_management_groups' do

  impact 1.0
  title 'Testing the plural resource of azurerm_management_groups.'
  desc 'Testing the plural resource of azurerm_management_groups.'

  only_if { !parent_mg.nil? }
  describe azurerm_management_groups do
    its('ids')           { should include "/providers/Microsoft.Management/managementGroups/#{parent_mg}" }
    its('ids')           { should include "/providers/Microsoft.Management/managementGroups/#{child1_mg}" }
    its('ids')           { should include "/providers/Microsoft.Management/managementGroups/#{child2_mg}" }
    its('names')         { should include parent_mg }
    its('names')         { should include child1_mg }
    its('names')         { should include child2_mg }
  end

  describe azurerm_management_groups.where(name: 'mg_parent').entries.first do
    its('properties') { should have_attributes(tenantId: tenant_id, displayName: parent_dn) }
  end
end
