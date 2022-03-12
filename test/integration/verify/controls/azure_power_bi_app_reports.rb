app_id = input(:app_id, value: '')

control 'Verify the settings of all Power BI App Reports' do
  describe azure_power_bi_app_reports(app_id: app_id) do
    it { should exist }
    its('names') { should include 'Finance' }
    its('webUrls') { should_not be_empty }
  end
end
