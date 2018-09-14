# frozen_string_literal: true

require 'azurerm_resource'

class AzurermSqlDatabase < AzurermSingularResource
  name 'azurerm_sql_database'
  desc 'Verifies settings for an Azure SQL Database'
  example <<-EXAMPLE
    describe azure_sql_database(resource_group: 'rg-1', server_name: 'sql-server-1' database_name: 'customer-db') do
      it { should exist }
    end
  EXAMPLE

  ATTRS = %i(
    id
    name
    kind
    location
    type
    sku
    properties
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, server_name: nil, database_name: nil)
    sql_database = management.sql_database(resource_group, server_name, database_name)
    return if has_error?(sql_database)

    assign_fields(ATTRS, sql_database)

    @resource_group = resource_group
    @server_name = server_name
    @database_name = database_name
    @exists = true
  end

  def auditing_settings
    management.sql_database_auditing_settings(@resource_group, @server_name, @database_name)
  end

  def threat_detection_settings
    management.sql_database_threat_detection_settings(@resource_group, @server_name, @database_name)
  end

  def encryption_settings
    management.sql_database_encryption(@resource_group, @server_name, @database_name)
  end

  def to_s
    "Azure SQL Database: '#{name}'"
  end
end
