# frozen_string_literal: true

require 'azurerm_resource'

class AzurermIotHub < AzurermSingularResource
  name 'azurerm_iothub'
  desc 'Verifies settings for Iot Hub'
  example <<-EXAMPLE
    describe azurerm_iothub(resource_group: 'example', resource_name: 'my-iot-hub') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  ATTRS = %i(
    name
    id
    type
    location
    properties
    tags
    etag
    sku
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, resource_name: nil)
    resp = management.iothub(resource_group, resource_name)
    return if has_error?(resp)

    assign_fields(ATTRS, resp)

    @exists = true
  end

  def to_s
    "'#{name}' IoT Hub"
  end
end
