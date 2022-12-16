require "azure_generic_resource"

class AzureServiceFabricMeshService < AzureGenericResource
  name "azure_service_fabric_mesh_service"
  desc "Retrieves and verifies the settings of an Azure Service Fabric Mesh Service."
  example <<-EXAMPLE
    describe azure_service_fabric_mesh_service(application_name: 'fabric-svc', name: 'svc') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.ServiceFabricMesh/applications", opts)
    opts[:resource_path] = [opts[:application_name], "services"].join("/")
    super(opts, true)
  end

  def to_s
    super(AzureServiceFabricMeshService)
  end
end
