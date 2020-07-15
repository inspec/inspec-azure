resource_group = input("resource_group", value: nil)

control "azurerm_aks_clusters" do
  describe azurerm_aks_clusters(resource_group: resource_group) do
    it           { should exist }
    its("names") { should be_an(Array) }
  end
end
