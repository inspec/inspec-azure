tenant_id = attribute('tenant_id', value: nil)
parent_mg = attribute('parent_mg', value: nil)
child1_mg = attribute('child1_mg', value: nil)
child2_mg = attribute('child2_mg', value: nil)
parent_dn = attribute('parent_dn', value: nil)

control 'azurerm_management_groups' do
  describe azurerm_management_groups do
    its('ids')           { should include "/providers/Microsoft.Management/managementGroups/#{parent_mg}" }
    its('ids')           { should include "/providers/Microsoft.Management/managementGroups/#{child1_mg}" }
    its('ids')           { should include "/providers/Microsoft.Management/managementGroups/#{child2_mg}" }
    its('names')         { should include parent_mg }
    its('names')         { should include child1_mg }
    its('names')         { should include child2_mg }
    its('types')         { should include '/providers/Microsoft.Management/managementGroups' }
  end

  describe azurerm_management_groups.where(name: 'mg_parent').entries.first do
    its('properties') { should have_attributes(tenantId: tenant_id, displayName: parent_dn) }
  end
end
