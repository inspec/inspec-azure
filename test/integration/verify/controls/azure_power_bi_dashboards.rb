group_id = input(:inspec_powerbi_workspace_id, value: '')
control 'verify settings of Power BI Dashboards in a group' do
  describe azure_power_bi_dashboards(group_id: group_id) do
    it { should exist }
    its('displayNames') { should include 'inspec-dev-dashboard' }
    its('isReadOnlies') { should include true }
    its('users') { should be_empty }
  end
end
