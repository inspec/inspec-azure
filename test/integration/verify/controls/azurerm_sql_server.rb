resource_group  = input('resource_group', value: nil)
sql_server_name = input('sql_server_name', value: nil)

control 'azurerm_sql_server' do
  only_if { !sql_server_name.nil? }

  describe azurerm_sql_server(resource_group: resource_group, server_name: sql_server_name) do
    it                { should exist }
    its('id')         { should_not be_nil }
    its('name')       { should eq sql_server_name }
    its('kind')       { should_not be_nil }
    its('location')   { should_not be_nil }
    its('type')       { should eq 'Microsoft.Sql/servers' }
    its('properties') { should have_attributes(version: '12.0') }
  end
end
