resource_group = attribute("resource_group", default: nil)
application_gateway_name = attribute("application_gateway_name", default: nil)

control "azurerm_application_gateways" do

  describe azurerm_application_gateways(resource_group: resource_group) do
    it           { should exist }
    its("names") { should include application_gateway_name }
  end

  describe azurerm_application_gateways do
    it            { should exist }
    its("names")  { should include application_gateway_name }
  end
end
