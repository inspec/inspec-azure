resource_group = input('resource_group',            value: nil)
nsg            = input('network_security_group',    value: nil)
nsg_id         = input('network_security_group_id', value: nil)
nsg_insecure   = input('network_security_group_insecure', value: nil)
nsg_open       = input('network_security_group_open', value: nil)

control 'azurerm_network_security_group' do

  impact 1.0
  title 'Testing the singular resource of azure_network_security_group.'
  desc 'Testing the singular resource of azure_network_security_group.'

  describe azurerm_network_security_group(resource_group: resource_group, name: nsg) do
    it                            { should exist }
    its('id')                     { should eq nsg_id }
    its('name')                   { should eq nsg }
    its('type')                   { should eq 'Microsoft.Network/networkSecurityGroups' }
    its('security_rules')         { should be_empty }
    its('default_security_rules') { should_not be_empty }
    it                            { should_not allow_rdp_from_internet }
    it                            { should_not allow_ssh_from_internet }
    it                            { should_not allow_port_from_internet('1433') }
    it                            { should_not allow_port_from_internet('1521') }
    it                            { should_not allow_port_from_internet('4333') }
    it                            { should_not allow_port_from_internet('5432') }
    it                            { should_not allow_port_from_internet('139') }
    it                            { should_not allow_port_from_internet('1433') }
    it                            { should_not allow_port_from_internet('445') }
    it                            { should_not allow_port_from_internet('1433') }
    it                            { should_not allow_port_from_internet('21') }
    it                            { should_not allow_port_from_internet('69') }
  end

  describe azurerm_network_security_group(resource_group: resource_group, name: nsg_insecure) do
    it                            { should exist }
    it                            { should allow_rdp_from_internet }
    it                            { should allow_ssh_from_internet }
    it                            { should allow_port_from_internet('1433') }
    it                            { should allow_port_from_internet('1521') }
    it                            { should allow_port_from_internet('4333') }
    it                            { should allow_port_from_internet('5432') }
    it                            { should allow_port_from_internet('139') }
    it                            { should allow_port_from_internet('1433') }
    it                            { should allow_port_from_internet('445') }
    it                            { should allow_port_from_internet('1433') }
    it                            { should allow_port_from_internet('21') }
    it                            { should allow_port_from_internet('69') }
  end

  describe azurerm_network_security_group(resource_group: resource_group, name: nsg_open) do
    it                            { should exist }
    it                            { should allow_rdp_from_internet }
    it                            { should allow_ssh_from_internet }
  end

  describe azurerm_network_security_group(resource_group: resource_group, name: 'fake') do
    it { should_not exist }
  end

  describe azurerm_network_security_group(resource_group: 'does-not-exist', name: nsg) do
    it { should_not exist }
  end
end

control 'azure_network_security_group' do

  impact 1.0
  title 'Testing the singular resource of azure_network_security_group.'
  desc 'Testing the singular resource of azure_network_security_group.'

  describe azure_network_security_group(resource_group: resource_group, name: nsg_insecure) do
    it { should allow_in(ip_range: '0.0.0.0', port: '22') }
    it { should_not allow_udp_from_internet }
    its('flow_log_retention_period') { should eq 0 }
    it { should allow(source_ip_range: '0.0.0.0', destination_port: '22', direction: 'inbound') }
    it { should allow_in(service_tag: 'Internet', port: %w{1433-1434 1521 4300-4350 5000-6000}) }
    it { should allow(source_service_tag: 'Internet', destination_port: %w{1433-1434 1521 4300-4350 5000-6000}, direction: 'inbound') }
    it { should allow_in(service_tag: 'Internet', port: '3389') }
    it { should allow(source_service_tag: 'Internet', destination_port: '3389', direction: 'inbound') }
  end

end
