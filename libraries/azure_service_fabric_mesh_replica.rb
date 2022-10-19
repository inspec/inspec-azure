require 'azure_generic_resource'

class AzureServiceFabricMeshReplica < AzureGenericResource
  name 'azure_service_fabric_mesh_replica'
  desc 'Retrieves and verifies the settings of an Azure Service Fabric Mesh Service Replicas.'
  example <<-EXAMPLE
    describe azure_service_fabric_mesh_replica(resource_group: 'RESOURCE_GROUP_NAME', 
                                                application_name: 'APP_NAME', 
                                                service_name: 'SERVICE_FABRIC_MESH_SERVICE_NAME', 
                                                name: 'SERVICE_FABRIC_MESH_SERVICE_REPLICA_NAME') do
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
