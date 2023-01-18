resource_group  = input("resource_group",        value: nil)
name            = input("subnet_name",           value: nil)
id              = input("subnet_id",             value: nil)
vnet            = input("vnet_name",             value: nil)
address_prefix  = input("subnet_address_prefix", value: nil)
nsg             = input("subnet_nsg",            value: nil)

control "azure_subnet_test_1" do
  title "Testing the singular resource of azure_subnet."
  desc "Testing the singular resource of azure_subnet."

  describe azure_subnet(resource_group: resource_group, vnet: vnet, name: name) do
    it                    { should exist }
    its("id")             { should eq id }
    its("name")           { should eq name }
    its("type")           { should eq "Microsoft.Network/virtualNetworks/subnets" }
    its("address_prefix") { should eq address_prefix }
    its("nsg")            { should eq nsg }
  end

  describe azure_subnet(resource_group: resource_group, vnet: vnet, name: "fake") do
    it { should_not exist }
  end

  describe azure_subnet(resource_group: "does-not-exist", vnet: vnet, name: name) do
    it { should_not exist }
  end
end

control "azure_subnet_test_2" do
  title "Ensure that azure_subnet supports `resource_id` as a parameter."
  desc "Testing the singular resource of azure_subnet."

  describe azure_subnet(resource_id: id) do
    its("name") { should cmp name }
  end
end
