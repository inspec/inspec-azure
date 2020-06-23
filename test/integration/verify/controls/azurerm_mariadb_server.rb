resource_group = input('resource_group', value: nil)
mariadb_server_name = input('mariadb_server_name', value: nil)

control 'azurerm_mariadb_server' do
  only_if { ENV['SQL'] }

  describe azurerm_mariadb_server(resource_group: resource_group, server_name: mariadb_server_name) do
    it                { should exist }
    its('id')         { should_not be_nil }
    its('name')       { should eq mariadb_server_name }
    its('sku')        { should_not be_nil }
    its('location')   { should_not be_nil }
    its('type')       { should eq 'Microsoft.DBforMariaDB/servers' }
    its('properties') { should have_attributes(version: '10.2') }
  end
end
