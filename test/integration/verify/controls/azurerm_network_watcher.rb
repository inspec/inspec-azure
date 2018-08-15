resource_group = attribute('resource_group',       default: nil)
nw             = attribute('network_watcher_name', default: nil).first
nw_id          = attribute('network_watcher_id',   default: nil).first

control 'azurerm_network_watcher' do
  only_if { ENV['NETWORK_WATCHER'] }

  describe azurerm_network_watcher(resource_group: resource_group, name: nw) do
    it                        { should exist }
    its('id')                 { should eq nw_id }
    its('name')               { should eq nw }
    its('type')               { should eq 'Microsoft.Network/networkWatchers' }
    its('provisioning_state') { should eq 'Succeeded' }
  end

  describe azurerm_network_watcher(resource_group: resource_group, name: 'fake') do
    it { should_not exist }
  end

  describe azurerm_network_watcher(resource_group: 'does-not-exist', name: nw) do
    it { should_not exist }
  end
end
