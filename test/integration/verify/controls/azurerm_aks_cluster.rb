resource_group = attribute('resource_group', default: nil)
cluster_fqdn   = attribute('cluster_fqdn',   default: nil)

control 'azurerm_aks_cluster' do
  describe azurerm_aks_cluster(resource_group: resource_group, name: 'inspecakstest') do
    it                          { should exist }
    its('name')                 { should cmp 'inspecakstest' }
    its('type')                 { should cmp 'Microsoft.ContainerService/managedClusters' }
    its('provisioning_state')   { should cmp 'Succeeded' }
    its('kubernetes_version')   { should cmp '1.9.9' }
    its('dns_prefix')           { should cmp 'inspecaksagent1' }
    its('fqdn')                 { should cmp cluster_fqdn }
    its('pool_name')            { should cmp 'inspecakstest' }
    its('pool_count')           { should cmp '5' }
    its('pool_vm_size')         { should cmp 'Standard_DS1_v2' }
    its('pool_storage_profile') { should cmp 'ManagedDisks' }
    its('pool_max_pods')        { should cmp '110' }
    its('pool_os_type')         { should cmp 'Linux' }
  end

  describe azurerm_aks_cluster(resource_group: resource_group, name: 'fake') do
    it { should_not exist }
  end

  describe azurerm_aks_cluster(resource_group: 'does-not-exist', name: nsg) do
    it { should_not exist }
  end
end
