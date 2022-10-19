control 'azure_virtual_machines' do
  impact 1.0
  title 'Testing the plural resource of azure_virtual_machines.'
  desc 'Testing the plural resource of azure_virtual_machines.'
  
  describe azure_virtual_machines(resource_group: 'example') do
    it { should exist }
  end
  
  describe azure_virtual_machines(resource_group: 'example') do
    its('ids') { should include '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/rgsoumyo/providers/Microsoft.Compute/virtualMachines/vmsoumyo' }
    its('names') { should include 'vmsoumyo' }
    its('types') { should include 'Microsoft.Compute/virtualMachines' }
    its('locations') { should include 'eastus' }
  end
end
