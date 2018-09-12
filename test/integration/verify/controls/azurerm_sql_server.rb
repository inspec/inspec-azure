resource_group  = attribute('resource_group', default: nil)
sql_server_name = attribute('sql_server_name', default: nil)

control 'azurerm_sql_server' do
  only_if { ENV['SQL'] }

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
