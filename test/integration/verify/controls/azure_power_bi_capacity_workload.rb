control "verify the settings of a Azure Power BI Capacity Workloads" do
  describe azure_power_bi_capacity_workload(capacity_id: "0f084df7-c13d-451b-af5f-ed0c466403b2", name: "Dataflows") do
    it { should exist }
    its("state") { should eq "Enabled" }
    its("name") { should eq "Dataflows" }
    its("maxMemoryPercentageSetByUser") { should eq "66" }
  end
end
