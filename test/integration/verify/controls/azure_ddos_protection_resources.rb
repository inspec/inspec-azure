resource_group = input('resource_group', value: nil)
ddos_protection_plan_name = input('ddos_protection_plan_name', value: nil)
df_location = input('ddos_protection_plan_location', value: nil)

control 'azure_ddos_protection_resources' do
  describe azure_ddos_protection_resources(resource_group: resource_group) do
    it { should exist }
    its('names') { should include ddos_protection_plan_name }
    its('locations') { should include df_location }
    its('types') { should include 'Microsoft.Network/ddosProtectionPlans' }
    its('provisioning_states') { should include('Succeeded') }
  end
end
