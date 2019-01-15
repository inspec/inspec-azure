# frozen_string_literal: true

require 'azurerm_resource'
require 'json'

class AzurermNetworkInterfaces < AzurermPluralResource
  name 'azurerm_network_interfaces'
  desc 'Verifies settings for a collection of Azure Network Interfaces'
  example <<-EXAMPLE
    describe azurerm_network_interfaces do
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
    network_interfaces = management.network_interfaces(resource_group)
    return if has_error?(network_interfaces)

    @table = network_interfaces
  end

  def to_s
    'Azure Network Interfaces'
  end
end
