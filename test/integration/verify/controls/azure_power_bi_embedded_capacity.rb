resource_group = input(:resource_group, value: '')
capacity_name = input(:power_bi_embedded_capacity_name, value: '')

control 'Verify settings for Azure Power BI Embedded Capacity' do
  describe azure_power_bi_embedded_capacity(resource_group: resource_group, name: capacity_name) do
    it { should exist }
  end
end
