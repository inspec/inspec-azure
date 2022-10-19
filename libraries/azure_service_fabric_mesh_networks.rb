require 'azure_generic_resources'

class AzureServiceFabricMeshNetworks < AzureGenericResources
  name 'azure_service_fabric_mesh_networks'
  desc 'Verifies settings for a collection of Azure Service Fabric Mesh Networks.'
  example <<-EXAMPLE
    describe azure_service_fabric_mesh_networks do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.ServiceFabricMesh/networks', opts)
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureServiceFabricMeshNetworks)
  end

  private

  def populate_table
    @resources.each do |resource|
      @table << resource.merge(resource[:properties]).merge(resource[:properties][:ingressConfig])
    end
  end
end
