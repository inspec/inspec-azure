control 'verify the settings of an Azure Power BI Capacity Refreshable' do
  describe azure_power_bi_capacity_refreshable(capacity_id: '0f084df7-c13d-451b-af5f-ed0c466403b2', refreshable_id: 'cfafbeb1-8037-4d0c-896e-a46fb27ff229') do
    it { should exist }
    its('refreshesPerDays') { should eq 11 }
    its('refreshCounts') { should eq 22 }
    its('kinds') { should eq 'Dataset' }
    its('refreshSchedules.enabled') { should be_truthy }
  end
end
