location = input(:location, value: '')

skip_control 'test the properties of all Azure Service Fabric Mesh Applications' do
  describe azure_service_fabric_mesh_volumes do
    it { should exist }
    its('names') { should include 'inspec-fb-mesh-vol' }
    its('providers') { should include 'SFAzureFile' }
    its('locations') { should include location.downcase.gsub("\s", '') }
    its('shareNames') { should include 'sharel' }
    its('provisioningStates') { should include 'Succeeded' }
  end
end
