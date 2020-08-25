resource_group = input('resource_group', value: nil)

control 'azurerm_aks_clusters' do
  describe azurerm_aks_clusters(resource_group: resource_group, api_version: '2018-03-31') do
    it           { should exist }
    its('names') { should be_an(Array) }
  end
end
