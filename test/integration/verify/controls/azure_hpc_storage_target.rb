resource_group = input(:resource_group, value: "")
location = input(:location, value: "")
cache_name = input(:inspec_hpc_cache_name, value: "")

control "Verify settings of an Azure HPC Storage Target" do
  describe azure_hpc_storage_target(resource_group: resource_group, cache_name: cache_name, name: "st1") do
    it { should exist }
    its("location") { should eq location.downcase.gsub("\s", "") }
    its("properties.targetType") { should eq "nfs3" }
    its("properties.state") { should eq "Ready" }
    its("properties.nfs3.target") { should eq "10.0.44.44" }
  end
end
