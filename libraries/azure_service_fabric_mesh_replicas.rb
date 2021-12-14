require 'azure_generic_resources'

class AzureServiceFabricMeshReplicas < AzureGenericResources
  name 'azure_service_fabric_mesh_replicas'
  desc 'Verifies settings for a collection of Azure Service Fabric Mesh Service Replicas'
  example <<-EXAMPLE
    describe azure_service_fabric_mesh_replicas(resource_group: 'inspec-def-rg', application_name: 'inspec-fabric-app-name', service_name: 'inspec-fabric-svc') do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.ServiceFabricMesh/applications', opts)
    opts[:resource_path] = [opts[:application_name], 'services', opts[:service_name], 'replicas'].join('/')
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureServiceFabricMeshReplicas)
  end
end
