resource_group = input("resource_group", value: nil)

control "azurerm_resource_groups" do
  describe azurerm_resource_groups do
    it                 { should exist }
    its("names")       { should include(resource_group) }
    its("tags")        { should include({}) }
  end

  describe azurerm_resource_groups.where(name: resource_group) do
    its("tags.first") { should include("ExampleTag" => "example") }
  end

end
