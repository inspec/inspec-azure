resource_group = input('resource_group', value: nil)
alert_rule_id = input('alert_rule_id', value: nil)
workspace_name = input('workspace_name', value: nil)
display_name = input('alert_rule_display_name', value: nil)
alert_rule_name = input('alert_rule_name', value: nil)

control 'azure_sentinel_alert_rule' do

  describe azure_sentinel_alert_rule(resource_group: resource_group, workspace_name: workspace_name, rule_id: alert_rule_id) do
    it { should exist }
    its('name') { should eq alert_rule_name }
    its('type') { should eq 'Microsoft.SecurityInsights/alertRules' }
    its('kind') { should eq 'Scheduled' }
    its('properties.displayName') { should eq display_name }
    its('properties.enabled') { should eq true }
    its('properties.severity') { should eq 'High' }
  end

  describe azure_sentinel_alert_rule(resource_group: 'fake', workspace_name: workspace_name, rule_id: 'fake') do
    it { should_not exist }
  end
end
