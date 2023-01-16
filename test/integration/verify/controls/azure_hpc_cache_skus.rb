describe azure_hpc_cache_skus do
  it { should exist }
  its("tier") { should eq "Standard" }
  its("size") { should eq "A0" }
end

describe azure_hpc_cache_skus.where(tier: "Standard") do
  it { should exist }
  its("size") { should eq "A0" }
end
