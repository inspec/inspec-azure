group_id = input(:inspec_powerbi_workspace_id, value: "")
dashboard_id = "b84b01c6-3262-4671-bdc8-ff99becf2a0b"
tile_id = "3262-4671-bdc8-"
control "Verify settings of a Power BI Dashboard tile" do
  describe azure_power_bi_dashboard_tile(group_id: group_id, dashboard_id: dashboard_id, tile_id: tile_id) do
    it { should exist }
  end
end
