resource_group = input(:resource_group, value: '')
resource_id = input(:windows_vm_id, value: '')

control 'azure_resource_health_events' do

  impact 1.0
  title 'Testing the plural resource of azure_resource_health_events.'
  desc 'Testing the plural resource of azure_resource_health_events.'

  describe azure_resource_health_events(resource_group: resource_group, resource_type: 'Microsoft.Compute/virtualMachines', resource_id: resource_id) do
    it { should exist }
    its('names') { should include 'BC_1-FXZ' }
    its('types') { should include '/providers/Microsoft.ResourceHealth/events' }
  end
end
