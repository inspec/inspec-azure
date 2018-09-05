# frozen_string_literal: true

require 'azurerm_resource'
require 'json'

class AzurermSqlServers < AzurermPluralResource
  name 'azurerm_sql_servers'
  desc 'Verifies settings for a collection of Azure SQL Servers'
  example <<-EXAMPLE
    describe azurerm_sql_servers do
        it  { should exist }
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
             .register_column(:ids,        field: :id)
             .register_column(:names,      field: :name)
             .register_column(:kinds,      field: :kind)
             .register_column(:locations,  field: :location)
             .register_column(:properties, field: :properties)
             .register_column(:tags,       field: :tag)
             .register_column(:types,      field: :type)
             .install_filter_methods_on_resource(self, :table)

  def initialize(resource_group: nil)
    servers = management.sql_servers(resource_group)
    return if has_error?(servers)

    @table = servers
  end

  def to_s
    'Azure SQL Servers'
  end
end
