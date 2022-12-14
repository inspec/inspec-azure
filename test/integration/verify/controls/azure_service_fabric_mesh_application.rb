resource_group = input(:resource_group, value: "")
location = input(:location, value: "")

skip_control "test the properties of an Azure Service Fabric Mesh Application" do
  describe azure_service_fabric_mesh_application(resource_group: resource_group, name: "inspec-fb-mesh-app") do
    it { should exist }
    its("name") { should eq "inspec-fb-mesh-app" }
    its("properties.status") { should eq "Ready" }
    its("location") { should eq location.downcase.gsub("\s", "") }
    its("properties.healthState") { should eq "healthState" }
    its("properties.provisioningState") { should eq "Succeeded" }
  end
end
