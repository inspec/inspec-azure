resource_group = attribute('resource_group', default: nil)
mysql_server_name = attribute('mysql_server_name', default: nil)
mysql_server_database = attribute('mysql_database_name', default: nil)

control 'azurerm_mysql_databases' do
  only_if { ENV['SQL'] }

  describe azurerm_mysql_databases(resource_group: resource_group, server_name: mysql_server_name) do
    it           { should exist }
    its('names') { should include mysql_server_database }
  end
end
