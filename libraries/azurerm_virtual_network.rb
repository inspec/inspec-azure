# frozen_string_literal: true

require 'azurerm_resource'

class AzurermVirtualNetwork < AzurermSingularResource
  name 'azurerm_virtual_network'
  desc 'Verifies settings for an Azure Virtual Network'
  example <<-EXAMPLE
    describe azurerm_virtual_network(resource_group: 'example', name: 'vnet-name') do
      it { should have_monitoring_agent_installed }
    end
  EXAMPLE

  ATTRS = %i(
    id
    name
    location
    type
    tags
    properties
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, name: nil)
    resp = management.virtual_network(resource_group, name)
    return if has_error?(resp)

    assign_fields(ATTRS, resp)

    @subs = Array(resp.properties.subnets) || []

    @exists = true
  end

  def address_space
    properties.addressSpace.addressPrefixes
  end

  def dns_servers
    properties.dhcpOptions.dnsServers
  end

  def vnet_peerings
    name_id = ->(peer) { [peer.name, peer.properties.remoteVirtualNetwork.id] }
    any_nils = ->(pair) { pair.any?(&:nil?) }

    properties.virtualNetworkPeerings.collect(&name_id).reject(&any_nils).to_h
  end

  def enable_ddos_protection
    properties.enableDdosProtection
  end

  def enable_vm_protection
    properties.enableVmProtection
  end

  def subnets
    @subs.collect(&:name)
  end

  def to_s
    "'#{name}' Virtual Network"
  end
end
