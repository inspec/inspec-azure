resource_group  = attribute('resource_group', default: nil)
sql_server_name = attribute('sql_server_name', default: nil)
sql_db_name     = attribute('sql_database_name', default: nil)

control 'azurerm_sql_database' do
  only_if { ENV['SQL'] }

  describe azurerm_sql_database(resource_group: resource_group,
                                server_name: sql_server_name,
                                database_name: sql_db_name) do
    it              { should exist }
    its('id')       { should_not be_nil }
    its('name')     { should eq sql_db_name }
    its('kind')     { should_not be_nil }
    its('location') { should_not be_nil }
    its('type')     { should eq 'Microsoft.Sql/servers/databases' }
  end
end
