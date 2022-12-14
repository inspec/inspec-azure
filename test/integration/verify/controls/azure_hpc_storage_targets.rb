resource_group = input(:resource_group, value: "")
location = input(:location, value: "")
cache_name = input(:inspec_hpc_cache_name, value: "")

control "Verify settings of all Azure HPC Storage Targets" do
  describe azure_hpc_storage_targets(resource_group: resource_group, cache_name: cache_name) do
    it { should exist }
    its("name") { should include "st1" }
    its("locations") { should include location.downcase.gsub("\s", "") }
    its("states") { should include "Ready" }
    its("targetTypes") { should include "nfs3" }
  end
end
