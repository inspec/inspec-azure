resource_group  = input('resource_group', value: nil)
sql_server_name = input('sql_server_name', value: nil)
sql_db_name     = input('sql_database_name', value: nil)

control 'azurerm_sql_database' do

  impact 1.0
  title 'Testing the singular resource of azure_sql_database.'
  desc 'Testing the singular resource of azure_sql_database.'

  only_if { !sql_db_name.nil? }

  describe azurerm_sql_database(resource_group: resource_group,
                                server_name: sql_server_name,
                                database_name: sql_db_name) do
    it { should exist }
    its('id') { should_not be_nil }
    its('name') { should eq sql_db_name }
    its('kind') { should_not be_nil }
    its('location') { should_not be_nil }
    its('type') { should eq 'Microsoft.Sql/servers/databases' }
  end
end

control 'azure_sql_database' do

  impact 1.0
  title 'Testing the singular resource of azure_sql_database.'
  desc 'Testing the singular resource of azure_sql_database.'

  only_if { !sql_db_name.nil? }

  sql_db_id = azure_sql_database(resource_group: resource_group,
                                 server_name: sql_server_name,
                                 name: sql_db_name).id
  describe azure_sql_database(resource_id: sql_db_id) do
    it { should exist }
    its('name') { should eq sql_db_name }
  end
end
