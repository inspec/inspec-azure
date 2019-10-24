# frozen_string_literal: true

require 'azurerm_resource'

class AzurermPostgreSQLServers < AzurermPluralResource
  name 'azurerm_postgresql_servers'
  desc 'Verifies settings for a collection of Azure PostgreSQL Servers'
  example <<-EXAMPLE
    describe azurerm_postgresql_servers do
        its('names')  { should include 'my-sql-server' }
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
             .register_column(:ids,        field: :id)
             .register_column(:names,      field: :name)
             .register_column(:skus,       field: :sku)
             .register_column(:locations,  field: :location)
             .register_column(:properties, field: :properties)
             .register_column(:types,      field: :type)
             .install_filter_methods_on_resource(self, :table)

  def initialize(resource_group: nil)
    servers = management.postgresql_servers(resource_group)
    return if has_error?(servers)

    @table = servers
  end

  def to_s
    'Azure PostgreSQL Servers'
  end
end
