# frozen_string_literal: true
resource_group = input("resource_group", value: nil)
resource_name = input("windows_vm_name", value: nil)
resource_type = "Microsoft.Compute/virtualMachines"

control "azurerm_locks" do
  describe azurerm_locks(resource_group: resource_group, resource_name: resource_name, resource_type: resource_type) do
    it { should_not exist }
  end
end
