tenant_id = attribute('tenant_id', default: nil)

control 'azurerm_management_group' do
  describe azurerm_management_group(group_id: 'mg_parent', expand: 'children', recurse: true) do
    it                            { should exist }
    its('id')                     { should eq '/providers/Microsoft.Management/managementGroups/mg_parent' }
    its('type')                   { should eq '/providers/Microsoft.Management/managementGroups' }
    its('name')                   { should eq 'mg_parent' }
    its('display_name')           { should eq 'Management Group Parent' }
    its('tenant_id')              { should eq tenant_id }
    its('children_display_names') { should include 'Management Group Child 1' }
    its('children_display_names') { should include 'Management Group Child 2' }
    its('children_ids')           { should include '/providers/Microsoft.Management/managementGroups/mg_child_one' }
    its('children_ids')           { should include '/providers/Microsoft.Management/managementGroups/mg_child_two' }
    its('children_names')         { should include 'mg_child_one' }
    its('children_names')         { should include 'mg_child_two' }
    its('children_types')         { should include '/providers/Microsoft.Management/managementGroups' }
  end

  describe azurerm_management_group(group_id: 'mg_child_one', expand: 'children', recurse: true) do
    it                            { should exist }
    its('id')                     { should eq '/providers/Microsoft.Management/managementGroups/mg_child_one' }
    its('type')                   { should eq '/providers/Microsoft.Management/managementGroups' }
    its('name')                   { should eq 'mg_child_one' }
    its('display_name')           { should eq 'Management Group Child 1' }
    its('tenant_id')              { should eq tenant_id }
    its('parent_name')            { should eq 'mg_parent' }
    its('parent_id')              { should eq '/providers/Microsoft.Management/managementGroups/mg_parent' }
    its('parent_display_name')    { should eq 'Management Group Parent' }
    its('children_display_names') { should eq [] }
    its('children_ids')           { should eq [] }
    its('children_names')         { should eq [] }
    its('children_types')         { should eq [] }
  end

  describe azurerm_management_group(group_id: 'mg_child_two', expand: 'children', recurse: true) do
    it                            { should exist }
    its('id')                     { should eq '/providers/Microsoft.Management/managementGroups/mg_child_two' }
    its('type')                   { should eq '/providers/Microsoft.Management/managementGroups' }
    its('name')                   { should eq 'mg_child_two' }
    its('display_name')           { should eq 'Management Group Child 2' }
    its('tenant_id')              { should eq tenant_id }
    its('parent_name')            { should eq 'mg_parent' }
    its('parent_id')              { should eq '/providers/Microsoft.Management/managementGroups/mg_parent' }
    its('parent_display_name')    { should eq 'Management Group Parent' }
    its('children_display_names') { should eq [] }
    its('children_ids')           { should eq [] }
    its('children_names')         { should eq [] }
    its('children_types')         { should eq [] }
  end
end
