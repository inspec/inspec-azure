location = input(:location, value: '')

control 'test the properties of all Azure Service Fabric Mesh Applications' do
  describe azure_service_fabric_mesh_applications do
    it { should exist }
    its('names') { should include 'inspec-fb-mesh-app' }
    its('statuses') { should include 'Ready' }
    its('locations') { should include location.downcase.gsub("\s", '') }
    its('healthStates') { should include 'healthState' }
    its('provisioningStates') { should include 'Succeeded' }
  end
end
