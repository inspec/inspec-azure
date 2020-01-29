# frozen_string_literal: true

require 'azurerm_resource'

class AzurermEventHubEventHub < AzurermSingularResource
  name 'azurerm_event_hub_event_hub'
  desc 'Verifies settings for Event Hub Event Hub'
  example <<-EXAMPLE
    describe azurerm_event_hub_event_hub(resource_group: 'example', namespace_name: 'namespace-ns', event_hub_name: 'eventHubName') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  ATTRS = %i(
    name
    id
    type
    properties
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, namespace_name: nil, event_hub_name: nil)
    resp = management.event_hub_event_hub(resource_group, namespace_name, event_hub_name)
    return if has_error?(resp)

    assign_fields(ATTRS, resp)

    @exists = true
  end

  def to_s
    "'#{name}' Event Hub Event Hub"
  end
end
