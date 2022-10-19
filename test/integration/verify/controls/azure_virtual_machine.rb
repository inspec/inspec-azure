control 'azure_virtual_machine' do
  impact 1.0
  title 'Testing the singular resource of azure_virtual_machine.'
  desc 'Testing the singular resource of azure_virtual_machine.'

  describe azure_virtual_machine(resource_group: 'rgsoumyo', name: 'vmsoumyo') do
    it { should exist }
  end

  describe azure_virtual_machine(resource_group: 'rgsoumyo', name: 'vmsoumyo') do
    it { should have_monitoring_agent_installed }
  end

  describe azure_virtual_machine(resource_group: 'rgsoumyo', name: 'vmsoumyo') do
    its('id') { should eq '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/rgsoumyo/providers/Microsoft.Compute/virtualMachines/vmsoumyo' }
    its('name') { should eq 'vmsoumyo' }
    its('type') { should eq 'Microsoft.Compute/virtualMachines' }
    its('location') { should eq 'eastus' }
  end
end
