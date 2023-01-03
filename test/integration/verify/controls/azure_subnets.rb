resource_group = input("resource_group", value: nil)
vnet           = input("vnet_name",      value: nil)
subnet         = input("subnet_name",    value: nil)

control "azure_subnets" do
  title "Testing the plural resource of azure_subnets."
  desc "Testing the plural resource of azure_subnets."

  describe azure_subnets(resource_group: resource_group, vnet: vnet) do
    it           { should exist }
    its("names") { should be_an(Array) }
    its("names") { should include(subnet) }
  end

  describe azure_subnets(resource_group: "fake-group", vnet: vnet) do
    it           { should_not exist }
    its("names") { should_not include("fake") }
  end

  describe azure_subnets(resource_group: resource_group, vnet: "fake") do
    it           { should_not exist }
    its("names") { should_not include("fake") }
  end

  describe azure_subnets(resource_group: resource_group, vnet: vnet)
    .where(name: subnet) do
      it { should exist }
    end
end
