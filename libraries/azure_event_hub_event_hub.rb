require 'azure_generic_resource'

class AzureEventHubEventHub < AzureGenericResource
  name 'azure_event_hub_event_hub'
  desc 'Verifies settings for Event Hub description'
  example <<-EXAMPLE
    describe azure_event_hub_event_hub(resource_group: 'example', namespace_name: 'namespace-ns', event_hub_name: 'eventHubName') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.EventHub/namespaces', opts)
    opts[:required_parameters] = %i(namespace_name)
    opts[:resource_path] = [opts[:namespace_name], 'eventhubs'].join('/')
    opts[:resource_identifiers] = %i(event_hub_name)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureEventHubEventHub)
  end
end

# Provide the same functionality under the old resource name.
# This is for backward compatibility.
class AzurermEventHubEventHub < AzureEventHubEventHub
  name 'azurerm_event_hub_event_hub'
  desc 'Verifies settings for Event Hub description'
  example <<-EXAMPLE
    describe azurerm_event_hub_event_hub(resource_group: 'example', namespace_name: 'namespace-ns', event_hub_name: 'eventHubName') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  def initialize(opts = {})
    Inspec::Log.warn Helpers.resource_deprecation_message(@__resource_name__, AzureEventHubEventHub.name)
    super
  end
end
