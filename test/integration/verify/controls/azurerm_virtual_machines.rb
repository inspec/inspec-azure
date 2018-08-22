resource_group     = attribute('resource_group',     default: nil)
vm_names           = attribute('vm_names',           default: nil)
os_disks           = attribute('os_disks',           default: nil)
data_disks         = attribute('managed_data_disks', default: nil)

windows_vm_names   = vm_names.select { |disk| disk.match(/windows/i) }
linux_vm_names     = vm_names.select { |disk| disk.match(/linux/i) }

windows_os_disks   = os_disks.select { |disk| disk.match(/windows/i) }
linux_os_disks     = os_disks.select { |disk| disk.match(/linux/i) }

windows_data_disks = data_disks.select { |disk| disk.match(/windows/i) }
linux_data_disks   = data_disks.select { |disk| disk.match(/linux/i) }

control 'azurerm_virtual_machines' do
  describe azurerm_virtual_machines(resource_group: resource_group) do
    it                             { should exist }
    its('vm_names.sort')           { should eq vm_names.sort }
    its('os_disks.sort')           { should eq os_disks.sort }
    its('data_disks.flatten.sort') { should eq data_disks.sort }
  end

  describe azurerm_virtual_machines(resource_group: resource_group)
    .where(platform: 'windows') do
    it                             { should exist }
    its('vm_names.sort')           { should eq windows_vm_names.sort }
    its('os_disks.sort')           { should eq windows_os_disks.sort }
    its('data_disks.flatten.sort') { should eq windows_data_disks.sort }
  end

  describe azurerm_virtual_machines(resource_group: resource_group)
    .where(platform: 'linux') do
    it                             { should exist }
    its('vm_names.sort')           { should eq linux_vm_names.sort }
    its('os_disks.sort')           { should eq linux_os_disks.sort }
    its('data_disks.flatten.sort') { should eq linux_data_disks.sort }
  end

  describe azurerm_virtual_machines(resource_group: 'fake-group') do
    it { should_not exist }
  end
end
