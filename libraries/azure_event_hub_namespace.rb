require 'azure_generic_resource'

class AzureEventHubNamespace < AzureGenericResource
  name 'azure_event_hub_namespace'
  desc 'Verifies settings for Event Hub Namespace.'
  example <<-EXAMPLE
    describe azure_event_hub_namespace(resource_group: 'RESOURCE_GROUP_NAME', name: 'namespace-ns') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.EventHub/namespaces', opts)
    opts[:resource_identifiers] = %i(namespace_name)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureEventHubNamespace)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermEventHubNamespace < AzureEventHubNamespace
  name 'azurerm_event_hub_namespace'
  desc 'Verifies settings for Event Hub Namespace'
  example <<-EXAMPLE
    describe azurerm_event_hub_namespace(resource_group: 'example', namespace_name: 'namespace-ns') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureEventHubNamespace.name)
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    # For backward compatibility.
    opts[:api_version] ||= '2017-04-01'
    super
  end
end
