location = input(:location, value: '')

control 'test the properties of all Azure Service Fabric Mesh Networks' do
  describe azure_service_fabric_mesh_networks do
    it { should exist }
    its('names') { should include 'inspec-fb-mesh-vol' }
    its('locations') { should include location.downcase.gsub("\s", '') }
    its('addressPrefixes') { should include '10.0.0.4/22' }
    its('provisioningStates') { should include 'Succeeded' }
  end
end
