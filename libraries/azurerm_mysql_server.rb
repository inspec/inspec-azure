# frozen_string_literal: true

require 'azurerm_resource'

class AzurermMySqlServer < AzurermSingularResource
  name 'azurerm_mysql_server'
  desc 'Verifies settings for an Azure My SQL Server'
  example <<-EXAMPLE
    describe azure_mysql_server(resource_group: 'rg-1', server_name: 'my-server-name') do
      it { should exist }
    end
  EXAMPLE

  ATTRS = %i(
    id
    name
    sku
    location
    type
    tags
    properties
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, server_name: nil)
    mysql_server = management.mysql_server(resource_group, server_name)
    return if has_error?(mysql_server)

    assign_fields(ATTRS, mysql_server)

    @resource_group = resource_group
    @server_name = server_name
    @exists = true
  end

  def firewall_rules
    management.mysql_server_firewall_rules(@resource_group, @server_name)
  end

  def to_s
    "Azure MySQL Server: '#{name}'"
  end
end
