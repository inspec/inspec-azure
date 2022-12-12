control 'Verify the settings of all Power BI App Capacities' do

  title 'Testing the plural resource of azure_power_bi_app_capacities.'
  desc 'Testing the plural resource of azure_power_bi_app_capacities.'

  describe azure_power_bi_app_capacities do
    it { should exist }
    its('skus') { should include 'A1' }
    its('states') { should include 'Active' }
    its('regions') { should include 'West Central US' }
    its('capacityUserAccessRights') { should include 'Admin' }
  end
end
