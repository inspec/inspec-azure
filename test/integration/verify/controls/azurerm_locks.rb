# frozen_string_literal: true
resource_group = attribute('resource_group', default: nil)
resource_name = attribute('windows_vm_name', default: nil)
resource_type = 'Microsoft.Compute/virtualMachines'

control 'azurerm_locks' do
  describe azurerm_locks(resource_group: resource_group, resource_name: resource_name, resource_type: resource_type) do
    it { should_not exist }
  end
end
