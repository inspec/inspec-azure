resource_group  = attribute('resource_group', default: nil)
sql_server_name = attribute('sql_server_name', default: nil)

control 'azurerm_sql_servers' do
  only_if { ENV['SQL'] }

  describe azurerm_sql_servers(resource_group: resource_group) do
    it           { should exist }
    its('names') { should include sql_server_name }
  end
end
