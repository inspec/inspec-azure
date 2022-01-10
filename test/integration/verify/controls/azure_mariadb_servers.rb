resource_group = input('resource_group', value: nil)
mariadb_server_name = input('mariadb_server_name', value: nil)

control 'azure_mariadb_servers' do
  only_if { !mariadb_server_name.nil? }

  describe azure_mariadb_servers(resource_group: resource_group) do
    it           { should exist }
    its('names') { should include mariadb_server_name }
  end

  describe azure_mariadb_servers do
    it            { should exist }
    its('names')  { should include mariadb_server_name }
  end
end
