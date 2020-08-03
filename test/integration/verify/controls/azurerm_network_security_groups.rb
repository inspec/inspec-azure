resource_group = input('resource_group', value: nil)

control 'azurerm_network_security_groups' do
  describe azurerm_network_security_groups(resource_group: resource_group) do
    it           { should exist }
    its('names') { should be_an(Array) }
  end
end

control 'azure_network_security_groups' do
  impact 1.0
  title 'Ensure that the resource tests all network security groups in a subscription.'

  describe azure_network_security_groups do
    it { should exist }
  end
end
