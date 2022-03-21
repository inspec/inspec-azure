require 'azure_generic_resource'

class AzureServiceFabricMeshReplica < AzureGenericResource
  name 'azure_service_fabric_mesh_replica'
  desc 'Retrieves and verifies the settings of an Azure Service Fabric Mesh Service Replicas'
  example <<-EXAMPLE
    describe azure_service_fabric_mesh_replica(resource_group: 'inspec-def-rg', application_name: 'inspec-fabric-app-name', service_name: 'inspec-fabric-svc', name: 'fabric-replica') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.ServiceFabricMesh/applications', opts)
    opts[:resource_path] = [opts[:application_name], 'services', opts[:service_name], 'replicas'].join('/')
    super(opts, true)
  end

  def to_s
    super(AzureServiceFabricMeshReplica)
  end
end
