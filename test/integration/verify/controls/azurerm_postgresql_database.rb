resource_group = input('resource_group', value: nil)
postgresql_server_name = input('postgresql_server_name', value: nil)
postgresql_database_name = input('postgresql_database_name', value: nil)

control 'azurerm_postgresql_database' do

  title 'Testing the singular resource of azurerm_postgresql_database.'
  desc 'Testing the singular resource of azurerm_postgresql_database.'

  only_if { !postgresql_database_name.nil? }

  describe azurerm_postgresql_database(resource_group: resource_group,
                                       server_name: postgresql_server_name,
                                       database_name: postgresql_database_name) do
    it              { should exist }
    its('id')       { should_not be_nil }
    its('name')     { should eq postgresql_database_name }
    its('type')     { should eq 'Microsoft.DBforPostgreSQL/servers/databases' }
  end
end
