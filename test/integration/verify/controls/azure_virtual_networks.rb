resource_group = input("resource_group", value: nil)
vnet = input("vnet_name", value: nil)

control "azure_virtual_networks" do
  title "Testing the plural resource of azure_virtual_networks."
  desc "Testing the plural resource of azure_virtual_networks."

  describe azure_virtual_networks(resource_group: resource_group) do
    it                              { should exist }
    its("names")                    { should be_an(Array) }
    its("names")                    { should include(vnet) }
  end

  describe azure_virtual_networks(resource_group: "fake-group") do
    it              { should_not exist }
    its("names")    { should_not include("fake") }
  end

  describe azure_virtual_networks(resource_group: resource_group)
    .where(name: vnet) do
      it { should exist }
    end
end
