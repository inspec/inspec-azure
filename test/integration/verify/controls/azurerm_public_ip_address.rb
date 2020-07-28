resource_group = attribute('resource_group', default: nil)
public_ip_address_name = attribute('public_ip_address_name', default: nil)

control 'azurerm_public_ip_address' do

  describe azurerm_public_ip_address(resource_group: resource_group, name: public_ip_address_name) do
    it                { should exist }
    its('id')         { should_not be_nil }
    its('name')       { should eq public_ip_address_name }
    its('location')   { should_not be_nil }
    its('type')       { should eq 'Microsoft.Network/publicIPAddresses' }
  end
end
