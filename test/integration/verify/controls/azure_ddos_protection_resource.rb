resource_group = input('resource_group', value: nil)
ddos_protection_plan_name = input('ddos_protection_plan_name', value: nil)
df_location = input('ddos_protection_plan_location', value: nil)

control 'azure_ddos_protection_resource' do

  title 'Testing the singular resource of azure_ddos_protection_resource.'
  desc 'Testing the singular resource of azure_ddos_protection_resource.'

  describe azure_ddos_protection_resource(resource_group: resource_group, name: ddos_protection_plan_name) do
    it { should exist }
    its('name') { should eq ddos_protection_plan_name }
    its('type') { should eq 'Microsoft.Network/ddosProtectionPlans' }
    its('provisioning_state') { should include('Succeeded') }
    its('location') { should include df_location }
  end

  describe azure_ddos_protection_resource(resource_group: resource_group, name: 'fake') do
    it { should_not exist }
  end

  describe azure_ddos_protection_resource(resource_group: 'fake', name: ddos_protection_plan_name) do
    it { should_not exist }
  end
end
