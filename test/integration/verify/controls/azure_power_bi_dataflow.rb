control 'verify the settings of all Azure Power BI Dataflows' do
  describe azure_power_bi_dataflow(group_id: 'f089354e-8366-4e18-aea3-4cb4a3a50b48') do
    it { should exist }
    its('objectId') { should eq 'bd32e5c0-363f-430b-a03b-5535a4804b9b' }
    its('name') { should eq 'AdventureWorks' }
  end
end
