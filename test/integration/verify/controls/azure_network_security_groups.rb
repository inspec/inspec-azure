resource_group = input("resource_group", value: nil)

control "azure_network_security_groups_test1" do
  title "Testing the plural resource of azure_network_security_groups."
  desc "Testing the plural resource of azure_network_security_groups."

  describe azure_network_security_groups(resource_group: resource_group) do
    it           { should exist }
    its("names") { should be_an(Array) }
  end
end

control "azure_network_security_groups_test2" do
  title "Ensure that the resource tests all network security groups in a subscription."
  desc "Testing the plural resource of azure_network_security_groups."

  describe azure_network_security_groups do
    it { should exist }
  end
end
