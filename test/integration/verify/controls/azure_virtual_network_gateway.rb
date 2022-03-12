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
