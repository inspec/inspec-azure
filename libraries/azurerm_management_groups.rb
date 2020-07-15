# frozen_string_literal: true

require "azurerm_resource"

class AzurermManagementGroups < AzurermPluralResource
  name "azurerm_management_groups"
  desc "Verifies settings for an Azure Management Groups"
  example <<-EXAMPLE
    describe azurerm_management_groups do
      its('names') { should include 'example-group' }
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
    .register_column(:ids, field: :id)
    .register_column(:types, field: :type)
    .register_column(:names, field: :name)
    .register_column(:properties, field: :properties)
    .install_filter_methods_on_resource(self, :table)

  def initialize
    resp = management.management_groups
    return if has_error?(resp)

    @table = resp
  end

  def to_s
    "Management Groups"
  end
end
