resource_group = input(:resource_group, value: "")

control "test the properties of an Azure Service Fabric Mesh Service" do
  describe azure_service_fabric_mesh_service(resource_group: resource_group, name: "fabric-svc") do
    it { should exist }
    its("name") { should eq "fabric-svc" }
    its("replicaCount") { should eq "2" }
    its("type") { should eq "Microsoft.ServiceFabricMesh/services" }
    its("healthState") { should eq "Ok" }
  end
end
