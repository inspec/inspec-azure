resource_group = input(:resource_group, value: '')
inspec_managed_app = input(:inspec_managed_app, value: '')

control 'test the properties of an Azure Managed APP' do
  describe azure_managed_application(resource_group: resource_group, name: inspec_managed_app) do
    it { should exist }
    its('kind') { should eq 'ServiceCatalog' }
    its('location') { should eq location }
    its('properties.provisioningState') { should eq 'Created' }
  end
end
