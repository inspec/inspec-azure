resource_group = input('resource_group', value: nil)
cluster_name = input('hdinsight_cluster_name', value: '')

control 'azure_hdinsight_cluster' do
  only_if { !cluster_name.empty? }
  describe azure_hdinsight_cluster(resource_group: resource_group, name: cluster_name) do
    it                                                       { should exist }
    its('name')                                              { should cmp cluster_name }
    its('type')                                              { should cmp 'Microsoft.HDInsight/clusters' }
    its('properties.provisioningState')                      { should cmp 'Succeeded' }
    its('properties.clusterVersion')                         { should cmp >= '4.0' }
    its('properties.clusterDefinition.kind')                 { should eq 'INTERACTIVEHIVE' }
  end

  describe azure_hdinsight_cluster(resource_group: resource_group, name: 'fake') do
    it { should_not exist }
  end

  describe azure_hdinsight_cluster(resource_group: 'does-not-exist', name: 'fake') do
    it { should_not exist }
  end
end
