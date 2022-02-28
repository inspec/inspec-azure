group_id = input(:inspec_powerbi_workspace_id, value: '')
dashboard_id = 'b84b01c6-3262-4671-bdc8-ff99becf2a0b'
control 'Verify settings of a Power BI Dashboard' do
  describe azure_power_bi_dashboard(group_id: group_id, dashboard_id: dashboard_id) do
    it { should exist }
    its('displayName') { should eq 'inspec-dev-dashboard' }
    its('isReadOnly') { should be_truthy }
    its('users') { should be_empty }
  end
end
