control 'verify the settings of all Azure Power BI Capacity Workloads' do
  describe azure_power_bi_capacity_workloads(capacity_id: '0f084df7-c13d-451b-af5f-ed0c466403b2') do
    it { should exist }
    its('refreshesPerDays') { should include 11 }
    its('refreshCounts') { should include 22 }
    its('kinds') { should include 'Dataset' }
    its('refreshSchedules') { should_not be empty }
  end
end
