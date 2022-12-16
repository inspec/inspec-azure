require "azure_generic_resources"

class AzureServiceFabricMeshServices < AzureGenericResources
  name "azure_service_fabric_mesh_services"
  desc "Verifies settings for a collection of Azure Service Fabric Mesh Services"
  example <<-EXAMPLE
    describe azure_service_fabric_mesh_services(application_name: 'fabric-svc') do
        it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.ServiceFabricMesh/applications", opts)
    opts[:resource_path] = [opts[:application_name], "services"].join("/")
    super(opts, true)
    return if failed_resource?

    populate_filter_table_from_response
  end

  def to_s
    super(AzureServiceFabricMeshServices)
  end

  private

  def populate_table
    @resources.each do |resource|
      resource = resource.merge(resource[:properties])
      @table << resource.merge(resource[:codePackages]).merge(resource[:networkRefs])
    end
  end
end
