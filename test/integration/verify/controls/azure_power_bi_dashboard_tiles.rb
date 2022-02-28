group_id = input(:inspec_powerbi_workspace_id, value: '')
control 'verify settings of all Power BI Dashboard Tiles in a group' do
  describe azure_power_bi_dashboards(group_id: group_id, dashboard_id: 'b84b01c6-3262-4671-bdc8-ff99becf2a0b') do
    it { should exist }
  end
end
