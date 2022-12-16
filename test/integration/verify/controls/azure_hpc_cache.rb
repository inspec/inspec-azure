name = input(:inspec_hpc_cache_name, value: "")
resource_group = input(:resource_group, value: "")
location = input(:location, value: "")

describe azure_hpc_cache(resource_group: resource_group, name: name) do
  it { should exist }
  its("location") { should eq location }
  its("provisioningState") { should eq "Succeeded" }
  its("properties.cacheSizeGB") { should eq 3072 }
end
