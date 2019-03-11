resource_group = attribute('resource_group', default: nil)
cluster_fqdn   = attribute('cluster_fqdn',   default: nil)

control 'azurerm_aks_cluster' do
  describe azurerm_aks_cluster(resource_group: resource_group, name: 'inspecakstest') do
    it                                                       { should exist }
    its('name')                                              { should cmp 'inspecakstest' }
    its('type')                                              { should cmp 'Microsoft.ContainerService/managedClusters' }
    its('properties.provisioningState')                      { should cmp 'Succeeded' }
    its('properties.dnsPrefix')                              { should cmp 'inspecaksagent1' }
    its('properties.fqdn')                                   { should cmp cluster_fqdn }
    its('properties.agentPoolProfiles.first.name')           { should cmp 'inspecaks' }
    its('properties.agentPoolProfiles.first.count')          { should cmp '5' }
    its('properties.agentPoolProfiles.first.vmSize')         { should cmp 'Standard_DS1_v2' }
    its('properties.agentPoolProfiles.first.storageProfile') { should cmp 'ManagedDisks' }
    its('properties.agentPoolProfiles.first.maxPods')        { should cmp '110' }
    its('properties.agentPoolProfiles.first.osType')         { should cmp 'Linux' }
    its('properties.kubernetesVersion')                      { should_not be nil }
  end

  describe azurerm_aks_cluster(resource_group: resource_group, name: 'fake') do
    it { should_not exist }
  end

  describe azurerm_aks_cluster(resource_group: 'does-not-exist', name: 'fake') do
    it { should_not exist }
  end
end
