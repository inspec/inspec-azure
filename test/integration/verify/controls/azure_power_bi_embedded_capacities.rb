capacity_name = input(:power_bi_embedded_capacity_name, value: '')

control 'Verify settings for Azure Power BI Embedded Capacity' do
  describe azure_power_bi_embedded_capacities do
    it { should exist }
    its('names') { should include capacity_name }
  end
end
