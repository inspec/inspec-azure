resource_group = input('resource_group', value: nil)
mysql_server_name = input('mysql_server_name', value: nil)

control 'azurerm_mysql_server' do

  title 'Testing the singular resource of azure_streaming_analytics_function.'
  desc 'Testing the singular resource of azure_streaming_analytics_function.'

  only_if { !mysql_server_name.nil? }
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

control 'azure_mysql_server' do

  title 'Testing the singular resource of azure_mysql_server.'
  desc 'Testing the singular resource of azure_mysql_server.'

  resource_id = azure_mysql_server(resource_group: resource_group, server_name: mysql_server_name).id

  describe azure_mysql_server(resource_id: resource_id) do
    it { should exist }
    its('name') { should eq mysql_server_name }
  end
end
