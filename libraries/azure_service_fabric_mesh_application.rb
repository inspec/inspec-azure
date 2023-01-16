require "azure_generic_resource"

class AzureServiceFabricMeshApplication < AzureGenericResource
  name "azure_service_fabric_mesh_application"
  desc "Retrieves and verifies the settings of an Azure Service Fabric Mesh Application."
  example <<-EXAMPLE
    describe azure_service_fabric_mesh_application(resource_group: 'inspec-def-rg', name: 'fabric-app') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.ServiceFabricMesh/applications", opts)
    super(opts, true)
  end

  def to_s
    super(AzureServiceFabricMeshApplication)
  end
end
