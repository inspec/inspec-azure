# frozen_string_literal: true

require 'azurerm_resource'

class AzurermRoleDefinitions < AzurermPluralResource
  name 'azurerm_role_definitions'
  desc 'Verifies settings for a collection of Azure Roles'
  example <<-EXAMPLE
    describe azurerm_role_definitions do
      its('names') { should include('role') }
    end
  EXAMPLE

  FilterTable.create
             .register_column(:ids, field: :id)
             .register_column(:names, field: :name)
             .register_column(:properties, field: :properties)
             .install_filter_methods_on_resource(self, :table)

  attr_reader :table

  def initialize
    resp = management.role_definitions
    return if has_error?(resp)

    @table = resp
  end

  def to_s
    'Role Definition'
  end
end
