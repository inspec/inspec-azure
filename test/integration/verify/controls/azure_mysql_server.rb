resource_group = input('resource_group', value: nil)
mysql_server_name = input('mysql_server_name', value: nil)

control 'azure_mysql_server' do
  only_if { !mysql_server_name.nil? }

  describe azure_mysql_server(resource_group: resource_group, server_name: mysql_server_name) do
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

  impact 1.0
  title 'Ensure resource_id is supported.'

  resource_id = azure_mysql_server(resource_group: resource_group, server_name: mysql_server_name).id

  describe azure_mysql_server(resource_id: resource_id) do
    it { should exist }
    its('name') { should eq mysql_server_name }
  end
end
