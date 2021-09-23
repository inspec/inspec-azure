resource_group = input(:resource_group, value: '')
power_bi_embedded_name = input(:power_bi_embedded_name, value: '')

control 'Verify settings for Azure Power BI Embedded Capacity' do
  describe azure_power_bi_embedded_capacity(resource_group: resource_group, name: power_bi_embedded_name) do
    it { should exist }
    its('properties.mode') { should include 'Gen2' }
    its('sku.name') { should eq 'A1' }
    its('sku.capacity') { should eq 1 }
  end
end
