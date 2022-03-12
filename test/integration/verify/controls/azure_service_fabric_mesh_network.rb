location = input(:location, value: '')
rg = input(:resource_group, value: '')

skip_control 'Test the properties of a Azure Service Fabric Mesh Network' do
  describe azure_service_fabric_mesh_networks(resource_group: rg, name: 'mesh-fabric-name') do
    it { should exist }
    its('location') { should eq location.downcase.gsub("\s", '') }
    its('addressPrefix') { should eq '10.0.0.4/22' }
    its('provisioningState') { should eq 'Succeeded' }
  end
end
