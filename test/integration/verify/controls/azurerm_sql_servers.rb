resource_group  = input('resource_group', value: nil)
sql_server_name = input('sql_server_name', value: nil)

control 'azurerm_sql_servers' do
  only_if { ENV['SQL'] }

  describe azurerm_sql_servers(resource_group: resource_group) do
    it           { should exist }
    its('names') { should include sql_server_name }
  end
end
