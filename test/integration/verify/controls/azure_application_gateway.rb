resource_group = input("resource_group", value: nil)
application_gateway_name = input("application_gateway_name", value: nil)

control "azure_application_gateway" do

  title "Testing the singular resource of azure_application_gateway."
  desc "Testing the singular resource of azure_application_gateway."

  describe azure_application_gateway(resource_group: resource_group, application_gateway_name: application_gateway_name) do
    it                { should exist }
    its("id")         { should_not be_nil }
    its("name")       { should eq application_gateway_name }
    its("location")   { should_not be_nil }
    its("type")       { should eq "Microsoft.Network/applicationGateways" }
    its("properties.sslPolicy.policyName") { should eq "AppGwSslPolicy20170401S" }
  end
end
