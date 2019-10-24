# frozen_string_literal: true

require 'azurerm_resource'
require 'ostruct'

class AzurermPostgreSQLServer < AzurermSingularResource
  name 'azurerm_postgresql_server'
  desc 'Verifies settings for an Azure PostgreSQL Server'
  example <<-EXAMPLE
    describe azure_postgresql_server(resource_group: 'rg-1', server_name: 'psql-srv') do
      it { should exist }
    end
  EXAMPLE

  ATTRS = %i(
    id
    name
    location
    sku
    type
    properties
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, server_name: nil)
    psql_server = management.postgresql_server(resource_group, server_name)
    return if has_error?(psql_server)

    assign_fields(ATTRS, psql_server)

    @resource_group = resource_group
    @server_name = server_name
    @exists = true
  end

  # Convenient access e.g. configurations.{config_name}.properties.value.eql?("on")
  def configurations
    @configurations ||= OpenStruct.new(
        management.postgresql_server_configurations(@resource_group, @server_name)
                  .map{|c| [c.name, c]}
                  .to_h
    )
  end

  def to_s
    "Azure PostgreSQL Server: '#{name}'"
  end
end
