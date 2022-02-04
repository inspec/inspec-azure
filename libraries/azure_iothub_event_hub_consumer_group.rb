require 'azure_generic_resource'

class AzureIotHubEventHubConsumerGroup < AzureGenericResource
  name 'azure_iothub_event_hub_consumer_group'
  desc 'Verifies settings for Iot Hub Event HUb Consumer Group'
  example <<-EXAMPLE
    describe azure_iothub_event_hub_consumer_group(resource_group: 'my-rg', resource_name: 'my-iot-hub', event_hub_endpoint: 'myeventhub', consumer_group: 'my-consumer-group') do
      its(name) { should eq 'my-consumer-group'}
    end
  EXAMPLE

  def initialize(opts = {})
    # Options should be Hash type. Otherwise Ruby will raise an error when we try to access the keys.
    raise ArgumentError, 'Parameters must be provided in an Hash object.' unless opts.is_a?(Hash)

    opts[:resource_provider] = specific_resource_constraint('Microsoft.Devices/IotHubs', opts)
    opts[:required_parameters] = %i(resource_name event_hub_endpoint)
    opts[:resource_path] = [opts[:resource_name], 'eventHubEndpoints', opts[:event_hub_endpoint], 'ConsumerGroups'].join('/')
    opts[:resource_identifiers] = %i(consumer_group)

    # static_resource parameter must be true for setting the resource_provider in the backend.
    super(opts, true)
  end

  def to_s
    super(AzureIotHubEventHubConsumerGroup)
  end
end
