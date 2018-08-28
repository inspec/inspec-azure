# frozen_string_literal: true

require 'azurerm_resource'

class AzurermSubnet < AzurermSingularResource
  name 'azurerm_subnet'
  desc 'Verifies settings for an Azure Virtual Network Subnet'
  example <<-EXAMPLE
    describe azurerm_subnet(resource_group: 'example',vnet: 'virtual-network-name' name: 'subnet-name') do
      it { should exist }
      its('name') { should eq 'subnet-name' }
    end
  EXAMPLE

  ATTRS = %i(
    id
    name
    type
    properties
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, vnet: nil, name: nil)
    resp = management.subnet(resource_group, vnet, name)
    return if has_error?(resp)

    assign_fields(ATTRS, resp)
    @exists = true
  end

  def address_prefix
    properties['addressPrefix']
  end

  def nsg
    properties.networkSecurityGroup.id.split('/')[-1]
  end

  def to_s
    "'#{name}' subnet"
  end
end
