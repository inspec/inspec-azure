app_id = input(:app_id, value: '')
dashboard_id = input(:dashboard_id, value: '')
control 'Verify the settings of a Power BI App Dashboard' do
  describe azure_power_bi_app_dashboard(app_id: app_id, dashboard_id: dashboard_id) do
    it { should exist }
  end
end
