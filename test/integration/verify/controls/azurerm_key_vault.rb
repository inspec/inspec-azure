resource_group = attribute('resource_group', default: nil)
vault_name     = attribute('key_vault_name', default: nil)

control 'azurerm_key_vault' do

  describe azurerm_key_vault(resource_group: resource_group, vault_name: vault_name) do
    it          { should exist }
    its('name') { should eq vault_name }
    its('type') { should eq 'Microsoft.KeyVault/vaults' }
  end
end
