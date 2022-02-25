app_id = input(:app_id, value: '')
dashboard_id = input(:dashboard_id, value: '')
tile_id = input(:tile_id, value: '')
control 'Verify the settings of a Power BI App Dashboard Tile' do
  describe azure_power_bi_app_dashboard_tile(app_id: app_id, dashboard_id: dashboard_id, tile_id: tile_id) do
    it { should exist }
    its('rowSpan') { should eq 0 }
    its('colSpan') { should eq 0 }
  end
end
