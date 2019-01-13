# frozen_string_literal: true

require 'azurerm_resource'
require 'json'

class AzurermLoadBalancers < AzurermPluralResource
  name 'azurerm_load_balancers'
  desc 'Verifies settings for a collection of Azure Load Balancers'
  example <<-EXAMPLE
    describe azurerm_load_balancers do
        it  { should exist }
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
             .register_column(:ids,        field: :id)
             .register_column(:names,      field: :name)
             .register_column(:skus,       field: :sku)
             .register_column(:locations,  field: :location)
             .register_column(:properties, field: :properties)
             .register_column(:tags,       field: :tag)
             .register_column(:types,      field: :type)
             .install_filter_methods_on_resource(self, :table)

  def initialize(resource_group: nil)
    loadbalancers = management.load_balancers(resource_group)
    return if has_error?(loadbalancers)

    @table = loadbalancers
  end

  def to_s
    'Azure Load balancers'
  end
end
