app_id = input(:app_id, value: '')
dashboard_id = input(:dashboard_id, value: '')
control 'Verify the settings of all Power BI App Dashboard Tiles' do
  describe azure_power_bi_app_dashboard_tiles(app_id: app_id, dashboard_id: dashboard_id) do
    it { should exist }
    its('rowSpan') { should include 0 }
    its('colSpan') { should include 0 }
  end
end
