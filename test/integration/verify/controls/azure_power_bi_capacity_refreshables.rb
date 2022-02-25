control 'verify the settings of all Azure Power BI Capacity Refreshables' do
  describe azure_power_bi_capacity_refreshables do
    it { should exist }
    its('refreshesPerDays') { should include 11 }
    its('refreshCounts') { should include 22 }
    its('kinds') { should include 'Dataset' }
    its('refreshSchedules') { should_not be empty }
  end
end
