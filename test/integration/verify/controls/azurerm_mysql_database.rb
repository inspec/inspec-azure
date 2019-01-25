resource_group = attribute('resource_group', default: nil)
mysql_server_name = attribute('mysql_server_name', default: nil)
mysql_db_name = attribute('mysql_database_name', default: nil)

control 'azurerm_mysql_database' do
  only_if { ENV['SQL'] }

  describe azurerm_mysql_database(resource_group: resource_group,
                                  server_name: mysql_server_name,
                                  database_name: mysql_db_name) do
    it              { should exist }
    its('id')       { should_not be_nil }
    its('name')     { should eq mysql_db_name }
    its('type')     { should eq 'Microsoft.DBforMySQL/servers/databases' }
  end
end
