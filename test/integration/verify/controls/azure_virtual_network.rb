control 'azure_virtual_network' do
  impact 1.0
  title 'Testing the singular resource of azure_virtual_network.'
  desc 'Testing the singular resource of azure_virtual_network.'
  
  describe azure_virtual_network(resource_group: 'rgsoumyo', name: 'rgsoumyo-vnet') do
    it { should exist }
  end
  
  describe azure_virtual_network(resource_group: 'rgsoumyo', name: 'rgsoumyo-vnet') do
    its('id') { should eq '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/rgsoumyo/providers/Microsoft.Network/virtualNetworks/rgsoumyo-vnet' }
    its('name') { should eq 'rgsoumyo-vnet' }
    its('type') { should eq 'Microsoft.Network/virtualNetworks' }
    its('location') { should eq 'eastus' }
    its('properties.provisioningState') { should eq 'Succeeded' }
  end
end
