resource_group = attribute('resource_group', value: nil)
application_gateway_name = attribute('application_gateway_name', value: nil)

control 'azurerm_application_gateway' do

  title 'Testing the singular resource of azure_streaming_analytics_function.'
  desc 'Testing the singular resource of azure_streaming_analytics_function.'

  describe azurerm_application_gateway(resource_group: resource_group, application_gateway_name: application_gateway_name) do
    it                { should exist }
    its('id')         { should_not be_nil }
    its('name')       { should eq application_gateway_name }
    its('location')   { should_not be_nil }
    its('type')       { should eq 'Microsoft.Network/applicationGateways' }
    its('properties.sslPolicy.policyName') { should eq 'AppGwSslPolicy20170401S' }
  end
end
