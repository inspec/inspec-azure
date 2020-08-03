# frozen_string_literal: true

require 'azurerm_resource'
require 'json'

class AzurermApiManagements < AzurermPluralResource
  name 'azurerm_api_managements'
  desc 'Verifies settings for a collection of Azure Api Management Services'
  example <<-EXAMPLE
    describe azurerm_api_managements do
        it  { should exist }
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
             .register_column(:ids,        field: :id)
             .register_column(:names,      field: :name)
             .register_column(:locations,  field: :location)
             .register_column(:properties, field: :properties)
             .register_column(:types,      field: :type)
             .install_filter_methods_on_resource(self, :table)

  def initialize(resource_group: nil)
    api_managements = management.api_managements(resource_group)
    return if has_error?(api_managements)

    @table = api_managements
  end

  def to_s
    'Azure Api Management Services'
  end
end
