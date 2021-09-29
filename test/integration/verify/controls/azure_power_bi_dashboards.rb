group_id = '95a4871a-33a4-4f35-9eea-8ff006b4840b'
control 'verify settings of Power BI Dashboards in a group' do
  describe azure_power_bi_dashboards(group_id: group_id) do
    it { should exist }
    its('displayNames') { should include 'inspec-dev-dashboard' }
    its('isReadOnlies') { should include true }
    its('users') { should be_empty }
  end
end
