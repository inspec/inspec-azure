control 'azure_virtual_networks' do
  impact 1.0
  title 'Testing the plural resource of azure_virtual_networks.'
  desc 'Testing the plural resource of azure_virtual_networks.'

  describe azure_virtual_networks(resource_group: 'rgsoumyo') do
    it { should exist }
  end

  describe azure_virtual_networks(resource_group: 'rgsoumyo') do
    its('ids') { should include '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/rgsoumyo/providers/Microsoft.Network/virtualNetworks/rgsoumyo-vnet' }
    its('names') { should include 'rgsoumyo-vnet' }
    its('types') { should include 'Microsoft.Network/virtualNetworks' }
    its('locations') { should include 'eastus' }
  end
end
