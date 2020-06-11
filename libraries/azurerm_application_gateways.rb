# frozen_string_literal: true

require 'azurerm_resource'
require 'json'

class AzurermApplicationGateways < AzurermPluralResource
  name 'azurerm_application_gateways'
  desc 'Verifies settings for a collection of Azure Application Gateways'
  example <<-EXAMPLE
    describe azurerm_application_gateways do
        it  { should exist }
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
             .register_column(:ids,        field: :id)
             .register_column(:names,      field: :name)
             .register_column(:locations,  field: :location)
             .register_column(:properties, field: :properties)
             .register_column(:tags,       field: :tag)
             .register_column(:types,      field: :type)
             .install_filter_methods_on_resource(self, :table)

  def initialize(resource_group: nil)
    application_gateways = management.application_gateways(resource_group)
    return if has_error?(application_gateways)

    @table = application_gateways
  end

  def to_s
    'Azure Application Gateways'
  end
end
