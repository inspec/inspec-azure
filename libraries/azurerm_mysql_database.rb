# frozen_string_literal: true

require 'azurerm_resource'

class AzurermMySqlDatabase < AzurermSingularResource
  name 'azurerm_mysql_database'
  desc 'Verifies settings for an Azure MySQL Database'
  example <<-EXAMPLE
    describe azure_mysql_database(resource_group: 'rg-1', server_name: 'mysql-server-1' database_name: 'customer-db') do
      it { should exist }
    end
  EXAMPLE

  ATTRS = %i(
    id
    name
    type
    properties
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, server_name: nil, database_name: nil)
    mysql_database = management.mysql_database(resource_group, server_name, database_name)
    return if has_error?(mysql_database)

    assign_fields(ATTRS, mysql_database)

    @resource_group = resource_group
    @server_name = server_name
    @database_name = database_name
    @exists = true
  end

  def to_s
    "Azure MySQL Database: '#{name}'"
  end
end
