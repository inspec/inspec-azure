resource_group = input('resource_group', value: nil)
mysql_server_name = input('mysql_server_name', value: nil)
mysql_server_database = input('mysql_database_name', value: nil)

control 'azurerm_mysql_databases' do

  impact 1.0
  title 'Testing the plural resource of azurerm_mysql_databases.'
  desc 'Testing the plural resource of azurerm_mysql_databases.'

  only_if { !mysql_server_database.nil? }

  describe azurerm_mysql_databases(resource_group: resource_group, server_name: mysql_server_name) do
    it           { should exist }
    its('names') { should include mysql_server_database }
  end
end
