# frozen_string_literal: true

require 'azurerm_resource'

class AzurermApplicationGateway < AzurermSingularResource
  name 'azurerm_application_gateway'
  desc 'Verifies settings for an Azure Application Gateway'
  example <<-EXAMPLE
    describe azurerm_application_gateway(resource_group: 'rg-1', application_gateway_name: 'lb-1') do
      it { should exist }
    end
  EXAMPLE

  ATTRS = %i(
    id
    name
    location
    type
    properties
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, application_gateway_name: nil)
    application_gateway = management.application_gateway(resource_group, application_gateway_name)
    return if has_error?(application_gateway)

    assign_fields(ATTRS, application_gateway)

    @resource_group = resource_group
    @application_gateway_name = application_gateway_name
    @exists = true
  end

  def to_s
    "Azure Application Gateway: '#{name}'"
  end
end
