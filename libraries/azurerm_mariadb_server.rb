# frozen_string_literal: true

require 'azurerm_resource'

class AzurermMariaDBServer < AzurermSingularResource
  name 'azurerm_mariadb_server'
  desc 'Verifies settings for an Azure MariaDB Server'
  example <<-EXAMPLE
    describe azure_mariadb_server(resource_group: 'rg-1', server_name: 'my-server-name') do
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
    mariadb_server = management.mariadb_server(resource_group, server_name)
    return if has_error?(mariadb_server)

    assign_fields(ATTRS, mariadb_server)

    @resource_group = resource_group
    @server_name = server_name
    @exists = true
  end

  def firewall_rules
    @firewall_rules ||= management.mariadb_server_firewall_rules(@resource_group, @server_name)
  end

  def to_s
    "Azure MariaDB Server: '#{name}'"
  end
end
