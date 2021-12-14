rg = input(:resource_group, value: '')
location = input(:location, value: '')

control 'test the properties of all Azure Service Fabric Mesh Applications' do
  describe azure_service_fabric_mesh_volume(resource_group: rg, name: 'mesh-volume-name') do
    it { should exist }
    its('properties.provider') { should eq 'SFAzureFile' }
    its('location') { should include location.downcase.gsub("\s", '') }
    its('properties.azureFileParameters.shareName') { should include 'sharel' }
    its('properties.provisioningState') { should include 'Succeeded' }
  end
end
