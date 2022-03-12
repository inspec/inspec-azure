# frozen_string_literal: true
resource_group = input('resource_group', value: nil)
resource_name = input('windows_vm_name', value: nil)
resource_type = 'Microsoft.Compute/virtualMachines'

control 'azurerm_locks' do

  impact 1.0
  title 'Testing the plural resource of azure_locks.'
  desc 'Testing the plural resource of azure_locks.'

  describe azurerm_locks(resource_group: resource_group, resource_name: resource_name, resource_type: resource_type) do
    it { should_not exist }
  end
end

control 'azure_locks' do

  impact 1.0
  title 'Testing the plural resource of azure_locks.'
  desc 'Testing the plural resource of azure_locks.'

  vm_id = azure_virtual_machine(resource_group: resource_group, name: resource_name).id
  describe azure_locks(resource_id: vm_id) do
    it { should_not exist }
  end
end
