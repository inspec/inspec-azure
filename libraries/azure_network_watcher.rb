# frozen_string_literal: true

require 'azurerm_network_watcher'

class AzureNetworkWatcher < AzurermNetworkWatcher
  name 'azure_network_watcher'
  desc '[DEPRECATED] Please use azurerm_network_watcher'
  example <<-EXAMPLE
    describe azure_network_watcher(resource_group: 'example', name: 'name') do
      its(name) { should eq 'name'}
    end
  EXAMPLE

  def initialize(resource_group: nil, name: nil)
    warn '[DEPRECATION] The `azure_network_watcher` resource is deprecated ' \
         'will be removed in version 2.0. Use the `azurerm_network_watcher` ' \
         'resource instead.'
    super
  end
end
