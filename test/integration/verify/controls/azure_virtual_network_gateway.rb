rg = input(:resource_group, value: '')
name = input(:inspec_vnw_gateway_name, value: '')

control 'Verify settings of an Azure Virtual Network Gateway' do

  impact 1.0
  title 'Testing the singular resource of azure_streaming_analytics_function.'
  desc 'Testing the singular resource of azure_streaming_analytics_function.'

  describe azure_virtual_network_gateway(resource_group: rg, name: name) do
    it { should exist }
    its('vpnClientConfiguration.vpnClientProtocols') { should include 'SSTP' }
    its('location') { should eq 'eastus' }
    its('provisioningState') { should eq 'Succeeded' }
    its('type') { should eq 'Microsoft.Network/virtualNetworkGateways' }
    its('gatewayType') { should eq 'Vpn' }
  end
end

control 'azure_virtual_network_gateway' do
  impact 1.0
  title 'Testing the singular resource of azure_virtual_network_gateway.'
  desc 'Testing the singular resource of azure_virtual_network_gateway.'
  
  describe azure_virtual_network_gateway(resource_group: 'omnibus-buildkite-chef-canary', name: 'vnsoumyo') do
    it{ should exist }
  end
  
  describe azure_virtual_network_gateway(resource_group: 'omnibus-buildkite-chef-canary', name: 'vnsoumyo') do
    its('id') { should eq '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/omnibus-buildkite-chef-canary/providers/Microsoft.Network/virtualNetworkGateways/vnsoumyo' }
    its('name') { should eq 'vnsoumyo' }
    its('location') { should eq 'westus2' }
    its('type') { should eq 'Microsoft.Network/virtualNetworkGateways' }
    its('properties.provisioningState') { should eq 'Created' }
    its('properties.packetCaptureDiagnosticState') { should eq 'None' }
    its('properties.enablePrivateIpAddress') { should eq false }
    its('properties.isMigrateToCSES') { should eq false }
  end
end
