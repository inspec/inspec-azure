resource_group            = input('resource_group',        value: nil)
win_name                  = input('windows_vm_name',       value: nil)
win_id                    = input('windows_vm_id',         value: nil)
win_location              = input('windows_vm_location',   value: nil)
win_tags                  = input('windows_vm_tags',       value: nil)
win_os_disk_name          = input('windows_vm_os_disk',    value: nil)
win_data_disk_names       = input('windows_vm_data_disks', value: nil)
win_monitoring_agent_name = input('monitoring_agent_name', value: nil)

control 'azure_virtual_machine' do
  describe azure_virtual_machine(resource_group: resource_group, name: win_name) do
    it                                { should exist }
    it                                { should have_monitoring_agent_installed }
    it                                { should_not have_endpoint_protection_installed([]) }
    it                                { should have_only_approved_extensions(['MicrosoftMonitoringAgent']) }
    its('id')                         { should eq win_id }
    its('name')                       { should eq win_name }
    its('location')                   { should eq win_location }
    its('tags')                       { should eq win_tags }
    its('type')                       { should eq 'Microsoft.Compute/virtualMachines' }
    its('zones')                      { should be_nil }
    its('os_disk_name')               { should eq win_os_disk_name }
    its('data_disk_names')            { should eq win_data_disk_names }
    its('installed_extensions_types') { should include('MicrosoftMonitoringAgent') }
    its('installed_extensions_names') { should include(win_monitoring_agent_name) }
  end

  describe azure_virtual_machine(resource_group: resource_group, name: 'fake') do
    it { should_not exist }
  end

  describe azure_virtual_machine(resource_group: 'does-not-exist', name: win_name) do
    it { should_not exist }
  end

  describe azure_virtual_machine(resource_group: resource_group, name: win_name) do
    its('properties.osProfile.linuxConfiguration.ssh') { should be_nil }
  end
end

control 'azure_virtual_machine' do
  impact 1.0
  title 'Ensure azure_virtual_machine accepts resource_id and tests resource_group as a property.'
  describe azure_virtual_machine(resource_id: win_id) do
    its('name') { should eq win_name }
    its('resource_group') { should eq resource_group }
  end
end
