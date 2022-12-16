require "azure_generic_resource"

class AzureServiceFabricMeshNetwork < AzureGenericResource
  name "azure_service_fabric_mesh_network"
  desc "Retrieves and verifies the settings of an Azure Service Fabric Mesh Network."
  example <<-EXAMPLE
    describe azure_service_fabric_mesh_network(resource_group: 'inspec-rg', name: 'fabric-vol') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.ServiceFabricMesh/networks", opts)
    super(opts, true)
  end

  def to_s
    super(AzureServiceFabricMeshNetwork)
  end
end
