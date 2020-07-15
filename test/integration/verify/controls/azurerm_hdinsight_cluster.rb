resource_group = input("resource_group", value: nil)

control "azurerm_hdinsight_cluster" do
  describe azurerm_hdinsight_cluster(resource_group: resource_group, name: "hdinsight-cluster") do
    it                                                       { should exist }
    its("name")                                              { should cmp "hdinsight-cluster" }
    its("type")                                              { should cmp "Microsoft.HDInsight/clusters" }
    its("properties.provisioningState")                      { should cmp "Succeeded" }
    its("properties.clusterVersion")                         { should cmp >= "4.0" }
    its("properties.clusterDefinition.kind")                 { should eq "INTERACTIVEHIVE" }
  end

  describe azurerm_hdinsight_cluster(resource_group: resource_group, name: "fake") do
    it { should_not exist }
  end

  describe azurerm_hdinsight_cluster(resource_group: "does-not-exist", name: "fake") do
    it { should_not exist }
  end
end
