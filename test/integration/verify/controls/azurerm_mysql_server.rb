resource_group = attribute('resource_group', default: nil)
mysql_server_name = attribute('mysql_server_name', default: nil)

control 'azurerm_mysql_server' do
  only_if { ENV['MYSQL'] }

  describe azurerm_mysql_server(resource_group: resource_group, server_name: mysql_server_name) do
    it                { should exist }
    its('id')         { should_not be_nil }
    its('name')       { should eq mysql_server_name }
    its('sku')        { should_not be_nil }
    its('location')   { should_not be_nil }
    its('type')       { should eq 'Microsoft.DBforMySQL/servers' }
    its('properties') { should have_attributes(version: '5.7') }
  end
end
