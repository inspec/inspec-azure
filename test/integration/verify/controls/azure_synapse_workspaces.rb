resource_group = input(:resource_group, value: "")
location = input(:location, value: "")
synapse_ws_name = input(:synapse_inspec_ws_name, value: "")

control "Verify settings of all Azure Synapse Workspaces" do
  describe azure_synapse_workspaces do
    it { should exist }
    its("names") { should include synapse_ws_name }
    its("locations") { should include location.downcase.gsub("\s", "") }
    its("provisioningStates") { should include "Succeeded" }
    its("managedResourceGroupNames") { should include resource_group }
    its("sqlAdministratorLogins") { should include "login" }
  end
end
