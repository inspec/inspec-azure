resource_group = input("resource_group", value: nil)
application_gateway_name = input("application_gateway_name", value: nil)

control "azure_application_gateways" do
  title "Testing the plural resource of azure_application_gateways."
  desc "Testing the plural resource of azure_application_gateways."

  describe azure_application_gateways(resource_group: resource_group) do
    it           { should exist }
    its("names") { should include application_gateway_name }
  end

  describe azure_application_gateways do
    it            { should exist }
    its("names")  { should include application_gateway_name }
  end
end
