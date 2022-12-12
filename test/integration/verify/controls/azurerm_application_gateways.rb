resource_group = attribute('resource_group', value: nil)
application_gateway_name = attribute('application_gateway_name', value: nil)

control 'azurerm_application_gateways' do

  title 'Testing the plural resource of azurerm_application_gateways.'
  desc 'Testing the plural resource of azurerm_application_gateways.'

  describe azurerm_application_gateways(resource_group: resource_group) do
    it           { should exist }
    its('names') { should include application_gateway_name }
  end

  describe azurerm_application_gateways do
    it            { should exist }
    its('names')  { should include application_gateway_name }
  end
end
