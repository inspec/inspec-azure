# frozen_string_literal: true

require "azurerm_resource"

class AzurermPostgreSQLDatabase < AzurermSingularResource
  name "azurerm_postgresql_database"
  desc "Verifies settings for an Azure PostgreSQL Database"
  example <<-EXAMPLE
    describe azure_postgresql_database(resource_group: 'rg-1', server_name: 'psql-server-1' database_name: 'customer-db') do
      it { should exist }
    end
  EXAMPLE

  ATTRS = %i{
    id
    name
    type
    properties
  }.freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, server_name: nil, database_name: nil)
    psql_db = management.postgresql_database(resource_group, server_name, database_name)
    return if has_error?(psql_db)

    assign_fields(ATTRS, psql_db)

    @resource_group = resource_group
    @server_name = server_name
    @database_name = database_name
    @exists = true
  end

  def to_s
    "Azure PostgreSQL Database: '#{name}'"
  end
end
