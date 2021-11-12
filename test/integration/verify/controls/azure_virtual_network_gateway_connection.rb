rg = input(:resource_group, value: '')
location = input(:location, value: '')
name = input(:vnw_gateway_connection, value: '')

control 'Verify settings of an Azure Virtual Network Gateway Connection' do
  describe azure_virtual_network_gateway_connection(resource_group: rg, name: name) do
    it { should exist }
    its('name') { should eq 'test' }
    its('location') { should eq location }
    its('provisioningState') { should eq 'Succeeded' }
    its('connectionType') { should eq 'Vnet2Vnet' }
    its('connectionProtocol') { should eq 'IKEv2' }
    its('ipsecPolicies.first.ikeEncryption') { should eq 'AES128' }
  end
end
