skip_control "test the properties of all Azure Service Fabric Mesh Service Replica" do
  describe azure_service_fabric_mesh_replicas(resource_group: "inspec-def-rg", application_name: "inspec-fabric-app-name", service_name: "inspec-fabric-svc", name: "inspec-fabric-replica") do
    it { should exist }
    its("osType") { should eq "Linux" }
    its("networkRefs") { should_not be_empty }
    its("replicaName") { should eq 1 }
  end
end
