resource_group = input("resource_group", value: nil)
workspace_name = input("workspace_name", value: nil)
display_name = input("alert_rule_display_name", value: nil)
alert_rule_name = input("alert_rule_name", value: nil)

control "azure_sentinel_alert_rules" do
  describe azure_sentinel_alert_rules(resource_group: resource_group, workspace_name: workspace_name) do
    it { should exist }
    its("names") { should include alert_rule_name }
    its("types") { should include "Microsoft.SecurityInsights/alertRules" }
    its("kinds") { should include "Fusion" }
    its("severities") { should include "High" }
    its("enableds") { should include true }
    its("displayNames") { should include display_name }
  end
end
