resource_group = input('resource_group', value: nil)
mysql_server_name = input('mysql_server_name', value: nil)

control 'azure_mysql_servers' do
  only_if { !mysql_server_name.nil? }

  describe azure_mysql_servers(resource_group: resource_group) do
    it           { should exist }
    its('names') { should include mysql_server_name }
  end

  describe azure_mysql_servers do
    it            { should exist }
    its('names')  { should include mysql_server_name }
  end
end
