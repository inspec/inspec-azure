location = input(:location, value: '')
rg = input(:resource_group, value: '')

control 'test the properties of all Azure Service Fabric Mesh Networks' do
  describe azure_service_fabric_mesh_networks(resource_group: rg, name: 'mesh-fabric-name') do
    it { should exist }
    its('location') { should eq location.downcase.gsub("\s", '') }
    its('addressPrefix') { should eq '10.0.0.4/22' }
    its('provisioningState') { should eq 'Succeeded' }
  end
end
