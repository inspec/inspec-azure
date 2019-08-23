tenant_id = attribute('tenant_id', default: nil)

control 'azurerm_management_groups' do
  describe azurerm_management_groups do
    its('group_ids')           { should include '/providers/Microsoft.Management/managementGroups/mg_child_one' }
    its('group_ids')           { should include '/providers/Microsoft.Management/managementGroups/mg_child_two' }
    its('group_names')         { should include 'mg_parent' }
    its('group_names')         { should include 'mg_child_one' }
    its('group_names')         { should include 'mg_child_two' }
    its('group_types')         { should include '/providers/Microsoft.Management/managementGroups' }
    its('group_tenant_ids')    { should include tenant_id }
    its('group_display_names') { should include 'Management Group Parent' }
    its('group_display_names') { should include 'Management Group Child 1' }
    its('group_display_names') { should include 'Management Group Child 2' }
  end
end
