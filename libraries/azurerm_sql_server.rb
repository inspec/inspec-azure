# frozen_string_literal: true

require 'azurerm_resource'

class AzurermSqlServer < AzurermSingularResource
  name 'azurerm_sql_server'
  desc 'Verifies settings for an Azure SQL Server'
  example <<-EXAMPLE
    describe azure_sql_server(resource_group: 'My Resource Group', name: 'my-server-name') do
      it { should exist }
    end
  EXAMPLE

  ATTRS = %i(
    id
    name
    kind
    location
    properties
    tags
    type
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, name: nil)
    sql_server = management.sql_server(resource_group, name)
    return if has_error?(sql_server)

    assign_fields(ATTRS, sql_server)

    @exists = true
  end

  def to_s
    "Azure SQL Server: '#{name}'"
  end
end
