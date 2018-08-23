# frozen_string_literal: true

require 'azurerm_resource'

class AzurermVirtualNetworkss < AzurermPluralResource
  name 'azurerm_virtual_networks'
  desc 'Verifies settings for Azure Virtual Networks'
  example <<-EXAMPLE
    azurerm_virtual_networks(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  FilterTable.create
             .register_column(:names, field: :name)
             .install_filter_methods_on_resource(self, :table)

  attr_reader :table

  def initialize(resource_group: nil)
    resp = client.virtual_networks(resource_group)
    return if has_error?(resp)

    @table = resp
  end

  def to_s
    'Azure Virtual Networks'
  end
end
