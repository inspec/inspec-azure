require 'azure_generic_resource'

class AzureContainerRegistry < AzureGenericResource
  name 'azure_container_registry'
  desc 'Verifies settings for an Azure Container Registry'
  example <<-EXAMPLE
    describe azure_container_registry(resource_group: 'rg-1', name: 'cr-1') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.ContainerRegistry/registries', opts)
    opts[:resource_identifiers] = %i(registry_name)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureContainerRegistry)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermContainerRegistry < AzureContainerRegistry
  name 'azurerm_container_registry'
  desc 'Verifies settings for an Azure Container Registry'
  example <<-EXAMPLE
    describe azurerm_container_registry(resource_group: 'rg-1', registry_name: 'lb-1') do
      it { should exist }
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureContainerRegistry.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2019-05-01'
    super
  end
end
