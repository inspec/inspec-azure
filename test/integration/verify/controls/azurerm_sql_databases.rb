resource_group      = attribute('resource_group', default: nil)
sql_server_name     = attribute('sql_server_name', default: nil)
sql_server_database = attribute('sql_database_name', default: nil)

control 'azurerm_sql_databases' do
  only_if { ENV['SQL'] }

  describe azurerm_sql_databases(resource_group: resource_group, server_name: sql_server_name) do
    it           { should exist }
    its('names') { should include sql_server_database }
  end
end
