resource_group = attribute('resource_group', default: nil)
postgresql_server_name = attribute('postgresql_server_name', default: nil)

control 'azurerm_postgresql_servers' do
  only_if { ENV['SQL'] }

  describe azurerm_postgresql_servers(resource_group: resource_group) do
    it           { should exist }
    its('names') { should include postgresql_server_name }
  end

  describe azurerm_postgresql_servers do
    it            { should exist }
    its('names')  { should include postgresql_server_name }
  end
end
