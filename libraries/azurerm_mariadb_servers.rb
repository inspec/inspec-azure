# frozen_string_literal: true

require 'azurerm_resource'
require 'json'

class AzurermMariaDBServers < AzurermPluralResource
  name 'azurerm_mariadb_servers'
  desc 'Verifies settings for a collection of Azure MariaDB Servers'
  example <<-EXAMPLE
    describe azurerm_mariadb_servers do
        its('names')  { should include 'mariadb-server' }
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
             .register_column(:ids,        field: :id)
             .register_column(:names,      field: :name)
             .register_column(:skus,       field: :sku)
             .register_column(:locations,  field: :location)
             .register_column(:properties, field: :properties)
             .register_column(:tags,       field: :tags)
             .register_column(:types,      field: :type)
             .install_filter_methods_on_resource(self, :table)

  def initialize(resource_group: nil)
    servers = management.mariadb_servers(resource_group)
    return if has_error?(servers)

    @table = servers
  end

  def to_s
    'Azure MariaDB Servers'
  end
end
