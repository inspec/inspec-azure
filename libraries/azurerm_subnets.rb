# frozen_string_literal: true

require 'azurerm_resource'

class AzurermSubnets < AzurermPluralResource
  name 'azurerm_subnets'
  desc 'Verifies settings for Azure Virtual Network Subnets'
  example <<-EXAMPLE
    azurerm_subnets(resource_group: 'example', vnet: 'virtual-network-name') do
      it{ should exist }
    end
  EXAMPLE

  FilterTable.create
             .register_column(:names, field: 'name')
             .install_filter_methods_on_resource(self, :table)

  attr_reader :table

  def initialize(resource_group: nil, vnet: nil)
    resp = client.subnets(resource_group, vnet)
    return if resp.nil? || (resp.is_a?(Hash) && resp.key?('error'))
    @vnet = vnet
    @table = resp
  end

  def to_s
    "Azure Subnets for virtual network: '#{@vnet}'"
  end
end
