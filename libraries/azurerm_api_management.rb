# frozen_string_literal: true

require 'azurerm_resource'

class AzurermApiManagement < AzurermSingularResource
  name 'azurerm_api_management'
  desc 'Verifies settings for an Azure Api Management Service'
  example <<-EXAMPLE
    describe azurerm_api_management(resource_group: 'rg-1', api_management_name: 'apim01') do
      it { should exist }
    end
  EXAMPLE

  ATTRS = %i(
    id
    name
    location
    type
    properties
    tags
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, api_management_name: nil)
    api_management = management.api_management(resource_group, api_management_name)
    return if has_error?(api_management)

    assign_fields(ATTRS, api_management)

    @resource_group = resource_group
    @api_management_name = api_management_name
    @exists = true
  end

  def to_s
    "Azure Api Management Service: '#{name}'"
  end
end
