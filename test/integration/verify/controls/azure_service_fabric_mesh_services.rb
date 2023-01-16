resource_group = input(:resource_group, value: "")

control "test the properties of all Azure Service Fabric Mesh Services" do
  describe azure_service_fabric_mesh_services(resource_group: resource_group) do
    it { should exist }
    its("names") { should include "fabric-svc" }
    its("replicaCounts") { should include "2" }
    its("types") { should include "Microsoft.ServiceFabricMesh/services" }
    its("healthStates") { should include "Ok" }
  end
end
