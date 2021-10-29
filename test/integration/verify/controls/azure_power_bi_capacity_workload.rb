control 'verify the settings of a Azure Power BI Capacity Workloads' do
  describe azure_power_bi_capacity_workload(capacity_id: '0f084df7-c13d-451b-af5f-ed0c466403b2', name: 'Dataflows') do
    it { should exist }
    its('refreshesPerDays') { should include 11 }
    its('refreshCounts') { should include 22 }
    its('kinds') { should include 'Dataset' }
    its('refreshSchedules') { should_not be empty }
  end
end
