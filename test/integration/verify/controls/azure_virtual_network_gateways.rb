control 'azure_virtual_network_gateways' do
  impact 1.0
  title 'Testing the plural resource of azure_virtual_network_gateways.'
  desc 'Testing the plural resource of azure_virtual_network_gateways.'

  describe azure_virtual_network_gateways(resource_group: 'omnibus-buildkite-chef-canary') do
    it { should exist }
  end

  describe azure_virtual_network_gateways(resource_group: 'omnibus-buildkite-chef-canary') do
    its('ids') { should include '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/omnibus-buildkite-chef-canary/providers/Microsoft.Network/virtualNetworkGateways/vnsoumyo' }
    its('names') { should include 'vnsoumyo' }
    its('locations') { should include 'westus2' }
    its('types') { should include 'Microsoft.Network/virtualNetworkGateways' }
  end
end
