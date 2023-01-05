require "azure_generic_resource"

class AzureContainerGroup < AzureGenericResource
  name "azure_container_group"
  desc "Retrieves and verifies the settings of a container group instance."
  example <<-EXAMPLE
    describe azure_container_group(resource_group: 'RESOURCE_GROUP_NAME', name: 'CONTAINER_GROUP_NAME') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    raise ArgumentError, "Parameters must be provided in an Hash object." unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint("Microsoft.ContainerInstance/containerGroups", opts)
    super(opts, true)
  end

  def to_s
    super(AzureContainerGroup)
  end
end
