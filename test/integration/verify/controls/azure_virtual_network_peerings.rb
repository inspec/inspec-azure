resource_group = input('resource_group',                    value: nil)
name           = input('virtual_network_peering_name',      value: nil)
vnet           = input('vnet_name',                         value: nil)

control 'azure_virtual_network_peerings' do
  describe azure_virtual_network_peerings(resource_group: resource_group, vnet: vnet) do
    it           { should exist }
    its('names') { should include(name) }
  end

  describe azure_virtual_network_peerings(resource_group: 'fake-group', vnet: vnet) do
    it           { should_not exist }
    its('names') { should_not include('fake') }
  end

  describe azure_virtual_network_peerings(resource_group: resource_group, vnet: vnet)
    .where(name: name) do
    it { should exist }
  end

end
