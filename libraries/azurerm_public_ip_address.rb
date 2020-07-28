# frozen_string_literal: true

require 'azurerm_resource'

class AzurermPublicIPAddress < AzurermSingularResource
  name 'azurerm_public_ip_address'
  desc 'Verifies settings for an Azure Public IP Address'
  example <<-EXAMPLE
    describe azure_public_ip_address(resource_group: 'rg-1', name: 'my-nic-name') do
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
    public_ip_address = management.public_ip_address(resource_group, name)
    return if has_error?(public_ip_address)

    assign_fields(ATTRS, public_ip_address)

    @resource_group = resource_group
    @name = name
    @exists = true
  end

  def ip_address
    properties.ipAddress || nil
  end

  def public_ip_address_version
    properties.publicIPAddressVersion || nil
  end

  def public_ip_allocation_method
    properties.publicIPAllocationMethod || nil
  end

  def idle_timeout_in_minutes
    properties.idleTimeoutInMinutes || nil
  end

  def ip_tags
    properties.ipTags || nil
  end

  def to_s
    "Azure Public IP Address: '#{name}'"
  end
end
