# frozen_string_literal: true

require 'azurerm_network_watchers'

class AzureNetworkWatchers < AzurermNetworkWatchers
  name 'azure_network_watchers'
  desc '[DEPRECATED] Please use azurerm_network_watchers'
  example <<-EXAMPLE
    azure_network_watchers(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  def initialize(resource_group:)
    warn '[DEPRECATION] The `azure_network_watchers` resource is deprecated ' \
         'and will be removed in version 2.0. Use the ' \
         '`azurerm_network_watchers` resource instead.'
    super
  end
end
