resource_group = input('resource_group', value: nil)
nw             = input('network_watcher_name', value: []).first

control 'azure_network_watchers' do
  only_if { !nw.nil? }

  describe azure_network_watchers(resource_group: resource_group) do
    it           { should exist }
    its('names') { should be_an(Array) }
  end
end

control 'azure_network_watchers' do
  only_if { !nw.nil? }

  azure_network_watchers.ids.each do |id|
    describe azure_network_watcher(resource_id: id) do
      it { should exist }
    end
  end
end
