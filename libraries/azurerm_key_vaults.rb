# frozen_string_literal: true

require 'azurerm_resource'
require 'json'

class AzurermKeyVaults < AzurermPluralResource
  name 'azurerm_key_vaults'
  desc 'Verifies settings for a collection of Azure Key Vaults'
  example <<-EXAMPLE
    describe azurerm_key_vaults(resource_group: 'rg-1') do
        it              { should exist }
        its('names')    { should include 'vault-1'}
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
             .register_column(:ids,        field: :id)
             .register_column(:names,      field: :name)
             .register_column(:locations,  field: :location)
             .register_column(:types,      field: :type)
             .register_column(:tags,       field: :tag)
             .register_column(:properties, field: :properties)
             .install_filter_methods_on_resource(self, :table)

  def initialize(resource_group: nil)
    vaults = management.key_vaults(resource_group)
    return if has_error?(vaults)

    @table = vaults
  end

  def to_s
    'Azure Key Vaults'
  end
end
