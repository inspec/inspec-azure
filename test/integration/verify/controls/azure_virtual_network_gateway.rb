rg = input(:resource_group, value: '')
name = input(:inspec_vnw_gateway_name, value: '')
describe azure_virtual_network_gateway(resource_group: rg, name: name) do
  it { should exist }
  its('vpnClientConfiguration.vpnClientProtocols') { should include 'SSTP' }
  its('location') { should eq 'eastus' }
  its('provisioningState') { should eq 'Succeeded' }
  its('type') { should eq 'Microsoft.Network/virtualNetworkGateways' }
  its('gatewayType') { should eq 'Vpn' }
end
