resource_group = input('resource_group', value: nil)
postgresql_server_name = input('postgresql_server_name', value: nil)

control 'azurerm_postgresql_servers' do

  impact 1.0
  title 'Testing the plural resource of azurerm_postgresql_servers.'
  desc 'Testing the plural resource of azurerm_postgresql_servers.'

  only_if { !postgresql_server_name.nil? }

  describe azurerm_postgresql_servers(resource_group: resource_group) do
    it           { should exist }
    its('names') { should include postgresql_server_name }
  end

  describe azurerm_postgresql_servers do
    it            { should exist }
    its('names')  { should include postgresql_server_name }
  end

  azure_postgresql_servers.ids.each do |id|
    describe azure_postgresql_server(resource_id: id) do
      it { should exist }
    end
  end
end
