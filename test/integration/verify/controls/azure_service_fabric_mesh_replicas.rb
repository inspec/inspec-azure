skip_control "test the properties of all Azure Service Fabric Mesh Service Replicas" do
  describe azure_service_fabric_mesh_replicas(resource_group: "inspec-def-rg", application_name: "inspec-fabric-app-name", service_name: "inspec-fabric-svc") do
    it { should exist }
    its("osTypes") { should include "Linux" }
    its("networkRefs") { should_not be_empty }
    its("replicaNames") { should include 1 }
  end
end
