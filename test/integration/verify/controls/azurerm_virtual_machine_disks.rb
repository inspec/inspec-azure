rg = attribute('resource_group', value: nil)
windows_vm_os_disk = attribute('windows_vm_os_disk', value: nil)

control 'azurerm_virtual_machine_disks' do
  describe azurerm_virtual_machine_disks do
    it                        { should exist }
    its('names')              { should include windows_vm_os_disk }
  end

  # rubocop:disable Lint/AmbiguousBlockAssociation
  describe azurerm_virtual_machine_disks.where { attached == true } do
    its('names') { should include windows_vm_os_disk }
  end

  describe azurerm_virtual_machine_disks.where { resource_group.casecmp(rg) } do
    its('names') { should include windows_vm_os_disk }
  end
  # rubocop:enable Lint/AmbiguousBlockAssociation
end