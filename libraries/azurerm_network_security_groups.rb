# frozen_string_literal: true

require 'azurerm_resource'

class AzurermNetworkSecurityGroups < AzurermResource
  name 'azurerm_network_security_groups'
  desc 'Verifies settings for Network Security Groups'
  example <<-EXAMPLE
    azurerm_network_security_groups(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
             .add_accessor(:entries)
             .add_accessor(:where)
             .add(:exists?) { |obj| !obj.entries.empty? }
             .add(:names, field: 'name')
             .connect(self, :table)

  def initialize(resource_group: nil)
    resp = client.network_security_groups(resource_group)
    return if resp.nil? || (resp.is_a?(Hash) && resp.key?('error'))

    @table = resp
  end

  def to_s
    'Network Security Groups'
  end
end
