resource_group = input('resource_group', value: nil)
postgresql_server_name = input('postgresql_server_name', value: nil)

control 'azurerm_postgresql_server' do
  only_if { !postgresql_server_name.nil? }

  describe azurerm_postgresql_server(resource_group: resource_group, server_name: postgresql_server_name) do
    it                { should exist }
    its('id')         { should_not be_nil }
    its('name')       { should eq postgresql_server_name }
    its('sku')        { should_not be_nil }
    its('location')   { should_not be_nil }
    its('type')       { should cmp 'Microsoft.DBforPostgreSQL/servers' }
    its('properties') { should have_attributes(version: '9.5') }
  end
end

resource_id = azure_postgresql_server(resource_group: resource_group, server_name: postgresql_server_name).id

control 'azure_postgresql_server' do
  only_if { !postgresql_server_name.nil? }

  describe azure_postgresql_server(resource_id: resource_id) do
    it                { should exist }
    its('id')         { should cmp resource_id }
    its('name')       { should eq postgresql_server_name }
    its('sku')        { should_not be_nil }
    its('location')   { should_not be_nil }
    its('type')       { should cmp 'Microsoft.DBforPostgreSQL/servers' }
    its('properties') { should have_attributes(version: '9.5') }
  end
end
