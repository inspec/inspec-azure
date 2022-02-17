app_id = input(:app_id, value: '')
control 'Verify the settings of all Power BI Apps' do
  describe azure_power_bi_apps do
    it { should exist }
    its('ids') { should include app_id }
  end
end
