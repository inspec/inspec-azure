require 'azure_generic_resource'

class AzureEventHubNamespace < AzureGenericResource
  name 'azure_event_hub_namespace'
  desc 'Verifies settings for Event Hub Namespace'
  example <<-EXAMPLE
    describe azure_event_hub_namespace(resource_group: 'example', name: 'namespace-ns') do
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
