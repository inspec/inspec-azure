# frozen_string_literal: true

require "azurerm_resource"

class AzurermLocks < AzurermPluralResource
  name "azurerm_locks"
  desc "Verifies settings for an Azure Lock on a Resource"
  example <<-EXAMPLE
    describe azurerm_locks(resource_group: 'my-rg', resource_name: 'my-vm', resource_type: 'Microsoft.Compute/virtualMachines') do
      it { should exist }
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
    .register_column(:ids,        field: :id)
    .register_column(:names,      field: :name)
    .register_column(:properties, field: :properties)
    .install_filter_methods_on_resource(self, :table)

  def initialize(resource_group: nil, resource_name: nil, resource_type: nil)
    resp = management.locks(resource_group, resource_name, resource_type)
    return if has_error?(resp)

    @table = resp
  end

  def to_s
    "Azure Locks"
  end
end
