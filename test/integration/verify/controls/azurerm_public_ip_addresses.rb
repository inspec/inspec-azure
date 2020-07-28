resource_group = attribute('resource_group', default: nil)
public_ip_address_name = attribute('public_ip_address_name', default: nil)

control 'azurerm_public_ip_addresses' do

  describe azurerm_public_ip_addresses(resource_group: resource_group) do
    it           { should exist }
    its('names') { should include public_ip_address_name }
  end
end
