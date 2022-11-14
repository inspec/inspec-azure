resource_group = input('resource_group', value: nil)
mysql_server_name = input('mysql_server_name', value: nil)

control 'azure_mysql_server_configuration' do
  impact 1.0
  title 'Testing the singular resource of azure_mysql_server_configuration.'
  desc 'Testing the singular resource of azure_mysql_server_configuration.'
  
  describe azure_mysql_server_configuration(resource_group: resource_group, server_name: mysql_server_name, name: 'audit_log_enabled') do
    it { should exist }
  end
  
  describe azure_mysql_server_configuration(resource_group: resource_group, server_name: mysql_server_name, name: 'audit_log_enabled') do
    its('id') { should_not be_empty }
    its('name') { should eq 'audit_log_enabled' }
    its('type') { should eq 'Microsoft.DBforMySQL/servers/configurations' }
  end
  
  describe azure_mysql_server_configuration(resource_group: resource_group, server_name: mysql_server_name, name: 'audit_log_enabled') do
    its('properties.value') { should eq 'ON' }
    its('properties.description') { should eq 'Allow to audit the log.' }
    its('properties.defaultValue') { should eq 'OFF' }
    its('properties.dataType') { should eq 'Enumeration' }
    its('properties.allowedValues') { should eq 'ON,OFF' }
    its('properties.source') { should eq 'user-override' }
    its('properties.isConfigPendingRestart') { should eq 'False' }
    its('properties.isDynamicConfig') { should eq 'True' }
  end
end
