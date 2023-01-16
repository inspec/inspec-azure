resource_group = input("resource_group", value: nil)
vault_name     = input("key_vault_name", value: nil)

control "azurerm_key_vaults" do

  title "Testing the plural resource of azurerm_key_vaults."
  desc "Testing the plural resource of azurerm_key_vaults."

  describe azurerm_key_vaults(resource_group: resource_group) do
    it           { should exist }
    its("names") { should include vault_name }
  end
end

control "azure_key_vaults" do

  title "Ensure that azure_key_vaults plural resource works without a parameter."
  desc "Testing the plural resource of azurerm_key_vaults."

  azure_key_vaults.ids.each do |id|
    describe azure_key_vault(resource_id: id) do
      its("type") { should eq "Microsoft.KeyVault/vaults" }
    end
  end

  describe azurerm_key_vaults(resource_group: resource_group) do
    it { should exist }
  end
end
