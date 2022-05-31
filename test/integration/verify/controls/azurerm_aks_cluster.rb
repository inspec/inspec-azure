resource_group = input('resource_group', value: nil)
cluster_fqdn   = input('cluster_fqdn',   value: nil)

control 'azurerm_aks_cluster' do

  impact 1.0
  title 'Testing the singular resource of azurerm_aks_cluster.'
  desc 'Testing the singular resource of azurerm_aks_cluster.'

  describe azurerm_aks_cluster(resource_group: resource_group, name: 'inspecakstest', api_version: '2018-03-31') do
    it                                                       { should exist }
    its('name')                                              { should cmp 'inspecakstest' }
    its('type')                                              { should cmp 'Microsoft.ContainerService/managedClusters' }
    its('properties.provisioningState')                      { should cmp 'Succeeded' }
    its('properties.dnsPrefix')                              { should cmp 'inspecaksagent1' }
    its('properties.fqdn')                                   { should cmp cluster_fqdn }
    its('properties.agentPoolProfiles.first.name')           { should cmp 'inspecaks' }
    its('properties.agentPoolProfiles.first.count')          { should cmp '2' }
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
