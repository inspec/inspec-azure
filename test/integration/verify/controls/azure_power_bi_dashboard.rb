group_id = '95a4871a-33a4-4f35-9eea-8ff006b4840b'
dashboard_id = '95a4871a-33a4-4f35'
control 'Verify settings of a Power BI Dashboard' do
  describe azure_power_bi_dashboard(group_id: group_id, dashboard_id: dashboard_id) do
    it { should exist }
  end
end
