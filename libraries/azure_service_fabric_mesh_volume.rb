require 'azure_generic_resource'

class AzureServiceFabricMeshVolume < AzureGenericResource
  name 'azure_service_fabric_mesh_volume'
  desc 'Retrieves and verifies the settings of an Azure Service Fabric Mesh Application.'
  example <<-EXAMPLE
    describe azure_service_fabric_mesh_volume(name: 'SERVICE_FABRIC_MESH_VOLUME_NAME') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.ServiceFabricMesh/volumes', opts)
    super(opts, true)
  end

  def to_s
    super(AzureServiceFabricMeshVolume)
  end
end
