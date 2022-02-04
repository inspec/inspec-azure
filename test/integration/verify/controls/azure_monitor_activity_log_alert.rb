resource_group = input('resource_group', value: nil)
log_alert_name = input('activity_log_alert_name', value: nil)

alerts_and_operations = {
  '5_3'  => 'Microsoft.Authorization/policyAssignments/write',
  '5_4'  => 'Microsoft.Network/networkSecurityGroups/write',
  '5_5'  => 'Microsoft.Network/networkSecurityGroups/delete',
  '5_6'  => 'Microsoft.Network/networkSecurityGroups/securityRules/write',
  '5_7'  => 'Microsoft.Network/networkSecurityGroups/securityRules/delete',
  '5_8'  => 'Microsoft.Security/securitySolutions/write',
  '5_9'  => 'Microsoft.Security/securitySolutions/delete',
  '5_10' => 'Microsoft.Sql/servers/firewallRules/write',
  '5_11' => 'Microsoft.Sql/servers/firewallRules/delete',
  '5_12' => 'Microsoft.Security/policies/write',
}

control 'azure_monitor_activity_log_alert' do
  alerts_and_operations.each do |alert, operation|
    describe azure_monitor_activity_log_alert(resource_group: resource_group, name: "#{log_alert_name}_#{alert}") do
      it                { should exist }
      its('operations') { should include operation }
      its('conditions') { should_not be_nil }
    end
  end

  describe azure_monitor_activity_log_alert(resource_group: resource_group, name: 'fake') do
    it { should_not exist }
  end
end
