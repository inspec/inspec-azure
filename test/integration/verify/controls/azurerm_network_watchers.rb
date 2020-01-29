resource_group = input('resource_group', value: nil)

control 'azurerm_network_watchers' do
  only_if { ENV['NETWORK_WATCHER'] }

  describe azurerm_network_watchers(resource_group: resource_group) do
    it           { should exist }
    its('names') { should be_an(Array) }
  end
end
