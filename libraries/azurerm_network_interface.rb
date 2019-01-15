# frozen_string_literal: true

require 'azurerm_resource'

class AzurermNetworkInterface < AzurermSingularResource
  name 'azurerm_network_interface'
  desc 'Verifies settings for an Azure Network Interface'
  example <<-EXAMPLE
    describe azure_network_interface(resource_group: 'rg-1', name: 'my-nic-name') do
      it { should exist }
    end
  EXAMPLE

  ATTRS = %i(
    id
    name
    location
    type
    properties
    tags
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, name: nil)
    network_interface = management.network_interface(resource_group, name)
    return if has_error?(network_interface)

    assign_fields(ATTRS, network_interface)

    @resource_group = resource_group
    @name = name
    @exists = true
  end

  def has_private_address_ip?
    !!properties.ipConfigurations[0].properties.privateIPAddress
  end

  def has_public_address_ip?
    !!properties.ipConfigurations[0].properties.publicIPAddress
  end

  def to_s
    "Azure Network Interface: '#{name}'"
  end
end
