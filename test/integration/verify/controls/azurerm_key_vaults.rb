resource_group = input("resource_group", value: nil)
vault_name     = input("key_vault_name", value: nil)

control "azurerm_key_vaults" do

  describe azurerm_key_vaults(resource_group: resource_group) do
    it           { should exist }
    its("names") { should include vault_name }
  end
end
