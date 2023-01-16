resource_group = attribute("resource_group", value: nil)
nic_name = attribute("windows_vm_nic_name", value: nil)

control "azurerm_network_interfaces" do

  title "Testing the plural resource of azurerm_network_interfaces."
  desc "Testing the plural resource of azurerm_network_interfaces."

  describe azurerm_network_interfaces(resource_group: resource_group) do
    it           { should exist }
    its("names") { should include nic_name }
  end
end
