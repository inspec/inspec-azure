resource_group        = attribute('resource_group',        default: nil)
vm                    = attribute('windows_vm_name',       default: nil)
vm_id                 = attribute('windows_vm_id',         default: nil)
location              = attribute('windows_vm_location',   default: nil)
tags                  = attribute('windows_vm_tags',       default: nil)
os_disk_name          = attribute('windows_vm_os_disk',    default: nil)
data_disk_names       = attribute('windows_vm_data_disks', default: nil)
monitoring_agent_name = attribute('monitoring_agent_name', default: nil)

control 'azurerm_virtual_machine' do
  describe azurerm_virtual_machine(resource_group: resource_group, name: vm) do
    it                                { should exist }
    it                                { should have_monitoring_agent_installed }
    it                                { should_not have_endpoint_protection_installed([]) }
    it                                { should have_only_approved_extensions(['MicrosoftMonitoringAgent']) }
    its('id')                         { should eq vm_id }
    its('name')                       { should eq vm }
    its('location')                   { should eq location }
    its('tags')                       { should eq tags }
    its('type')                       { should eq 'Microsoft.Compute/virtualMachines' }
    its('zones')                      { should be_nil }
    its('os_disk_name')               { should eq os_disk_name }
    its('data_disk_names')            { should eq data_disk_names }
    its('installed_extensions_types') { should include('MicrosoftMonitoringAgent') }
    its('installed_extensions_names') { should include(monitoring_agent_name) }
  end

  describe azurerm_virtual_machine(resource_group: resource_group, name: 'fake') do
    it { should_not exist }
  end

  describe azurerm_virtual_machine(resource_group: 'does-not-exist', name: vm) do
    it { should_not exist }
  end
end
