require 'azure_generic_resource'

class AzureAksCluster < AzureGenericResource
  name 'azure_aks_cluster'
  desc 'Verifies settings for AKS Clusters'
  example <<-EXAMPLE
    describe azure_aks_cluster(resource_group: 'example', name: 'name') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.ContainerService/managedClusters', opts)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureAksCluster)
  end

  def enabled_logging_types
    return unless exists?
    additional_resource_properties(
      {
        property_name: 'diagnostic_settings',
        property_endpoint: id + '/providers/microsoft.insights/diagnosticSettings',
        api_version: '2017-05-01-preview',
      },
    ).first.properties.logs.select(&:enabled).map{|type| type.category}
  end

  def disabled_logging_types
    return unless exists?
    additional_resource_properties(
      {
        property_name: 'diagnostic_settings',
        property_endpoint: id + '/providers/microsoft.insights/diagnosticSettings',
        api_version: '2017-05-01-preview',
      },
    ).first.properties.logs.reject(&:enabled).map{|type| type.category}
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermAksCluster < AzureAksCluster
  name 'azurerm_aks_cluster'
  desc 'Verifies settings for AKS Clusters'
  example <<-EXAMPLE
    describe azurerm_aks_cluster(resource_group: 'example', name: 'name') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureAksCluster.name)
    super
  end
end
