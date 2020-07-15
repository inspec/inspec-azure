# frozen_string_literal: true

require "azurerm_resource"

class AzurermIotHubEventHubConsumerGroup < AzurermSingularResource
  name "azurerm_iothub_event_hub_consumer_group"
  desc "Verifies settings for Iot Hub Event HUb Consumer Group"
  example <<-EXAMPLE
    describe azurerm_iothub_event_hub_consumer_group(resource_group: 'my-rg', resource_name 'my-iot-hub', event_hub_endpoint: 'myeventhub', consumer_group: 'my-consumer-group') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  ATTRS = %i{
    name
    id
    type
    properties
    etag
  }.freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, resource_name: nil, event_hub_endpoint: nil, consumer_group: nil)
    resp = management.iothub_event_hub_consumer_group(resource_group, resource_name, event_hub_endpoint, consumer_group)
    return if has_error?(resp)

    assign_fields(ATTRS, resp)
    @exists = true
  end

  def to_s
    "'#{name}' IoT Hub Event Hub Consumer Group"
  end
end
