resource_group = input("resource_group", value: nil)
nic_name = input("windows_vm_nic_name", value: nil)

control "azure_network_interfaces" do
  title "Testing the plural resource of azure_network_interfaces."
  desc "Testing the plural resource of azure_network_interfaces."

  describe azure_network_interfaces(resource_group: resource_group) do
    it           { should exist }
    its("names") { should include nic_name }
  end
end
