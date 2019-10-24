resource_group = attribute('resource_group', default: nil)
postgresql_server_name = attribute('postgresql_server_name', default: nil)

control 'azurerm_postgresql_server' do
  only_if { ENV['SQL'] }

  describe azurerm_postgresql_server(resource_group: resource_group, server_name: postgresql_server_name) do
    it                { should exist }
    its('id')         { should_not be_nil }
    its('name')       { should eq postgresql_server_name }
    its('sku')        { should_not be_nil }
    its('location')   { should_not be_nil }
    its('type')       { should eq 'Microsoft.DBforPostgreSQL/servers' }
    its('properties') { should have_attributes(version: '9.5') }
  end
end
