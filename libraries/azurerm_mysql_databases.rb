# frozen_string_literal: true

require 'azurerm_resource'
require 'json'

class AzurermMySqlDatabases < AzurermPluralResource
  name 'azurerm_mysql_databases'
  desc 'Verifies settings for a collection of Azure MySQL Databases on a MySQL Server'
  example <<-EXAMPLE
    describe azurerm_mysql_databases(resource_group: 'my-rg', server_name: 'server-1') do
        it            { should exist }
        its('names')  { should_not be_empty }
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
             .register_column(:ids,        field: :id)
             .register_column(:names,      field: :name)
             .register_column(:properties, field: :properties)
             .register_column(:types,      field: :type)
             .install_filter_methods_on_resource(self, :table)

  def initialize(resource_group: nil, server_name: nil)
    databases = management.mysql_databases(resource_group, server_name)
    return if has_error?(databases)

    @table = databases
  end

  def to_s
    'Azure MySQL Databases'
  end
end
