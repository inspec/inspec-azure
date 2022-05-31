resource_group = attribute('resource_group', value: nil)
iothub_resource_name = attribute('iothub_resource_name', value: nil)

control 'azurerm_iothub' do

  impact 1.0
  title 'Testing the singular resource of azurerm_iothub.'
  desc 'Testing the singular resource of azurerm_iothub.'

  describe azurerm_iothub(resource_group: resource_group, resource_name: iothub_resource_name) do
    it          { should exist }
    its('name') { should eq iothub_resource_name }
    its('type') { should eq 'Microsoft.Devices/IotHubs' }
  end

  describe azurerm_iothub(resource_group: resource_group, resource_name: 'fake') do
    it { should_not exist }
  end
end
