resource_group = input('resource_group', value: nil)
mysql_server_name = input('mysql_server_name', value: nil)

control 'azure_mysql_database_configurations' do
  title 'Testing the plural resource of azure_mysql_database_configurations.'
  desc 'Testing the plural resource of azure_mysql_database_configurations.'

  describe azure_mysql_database_configurations(resource_group: resource_group, server_name: mysql_server_name) do
    it { should exist }
  end

  describe azure_mysql_database_configurations(resource_group: resource_group, server_name: mysql_server_name) do
    its('ids') { should_not be_empty }
    its('names') { should include 'audit_log_enabled' }
    its('types') { should include 'Microsoft.DBforMySQL/servers/configurations' }
    its('properties') { should_not be_empty }
  end
end
