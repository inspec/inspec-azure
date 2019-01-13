resource_group = attribute('resource_group', default: nil)
mysql_server_name = attribute('mysql_server_name', default: nil)

control 'azurerm_mysql_servers' do
  only_if { ENV['MYSQL'] }

  describe azurerm_mysql_servers(resource_group: resource_group) do
    it           { should exist }
    its('names') { should include mysql_server_name }
  end

  describe azurerm_mysql_servers do
    it            { should exist }
    its('names')  { should include mysql_server_name }
  end
end
