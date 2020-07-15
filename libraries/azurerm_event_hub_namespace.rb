# frozen_string_literal: true

require "azurerm_resource"

class AzurermEventHubNamespace < AzurermSingularResource
  name "azurerm_event_hub_namespace"
  desc "Verifies settings for Event Hub Namespace"
  example <<-EXAMPLE
    describe azurerm_event_hub_namespace(resource_group: 'example', namespace_name: 'namespace-ns') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  ATTRS = %i{
    name
    sku
    id
    type
    location
    properties
    tags
  }.freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, namespace_name: nil)
    resp = management.event_hub_namespace(resource_group, namespace_name)
    return if has_error?(resp)

    assign_fields(ATTRS, resp)

    @exists = true
  end

  def to_s
    "'#{name}' Event Hub Namespace"
  end
end
