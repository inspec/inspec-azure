resource_group = input(:resource_group, value: '')
inspec_managed_app = input(:inspec_managed_app, value: '')
location = input(:location, value: '')

control 'test the properties of all Azure Service Bus Namespaces' do
  describe azure_managed_applications(resource_group: resource_group) do
    it { should exist }
    its('names') { should include inspec_managed_app }
    its('managementModes') { should include 'Managed' }
    its('locations') { should include location }
    its('types') { should include 'Microsoft.Solutions/applications' }
    its('provisioningStates') { should include 'Created' }
  end
end
