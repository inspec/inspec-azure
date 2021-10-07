app_id = input(:app_id, value: '')
control 'Verify the settings of all Power BI App Dashboards' do
  describe azure_power_bi_app_dashboards(app_id: app_id) do
    it { should exist }
  end
end
