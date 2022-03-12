resource_group = input('resource_group', value: nil)
nw             = input('network_watcher_name', value: []).first

control 'azurerm_network_watchers' do

  impact 1.0
  title 'Testing the plural resource of azurerm_network_watchers.'
  desc 'Testing the plural resource of azurerm_network_watchers.'

  only_if { !nw.nil? }

  describe azurerm_network_watchers(resource_group: resource_group) do
    it           { should exist }
    its('names') { should be_an(Array) }
  end
end

control 'azure_network_watchers' do

  impact 1.0
  title 'Testing the plural resource of azurerm_network_watchers.'
  desc 'Testing the plural resource of azurerm_network_watchers.'

  only_if { !nw.nil? }

  azurerm_network_watchers.ids.each do |id|
    describe azure_network_watcher(resource_id: id) do
      it { should exist }
    end
  end

  describe azure_network_watcher(resource_id: 'dummy') do
    it { should_not exist }
  end
end
