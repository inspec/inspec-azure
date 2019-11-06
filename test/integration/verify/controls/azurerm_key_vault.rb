resource_group = input('resource_group', value: nil)
vault_name     = input('key_vault_name', value: nil)

control 'azurerm_key_vault' do

  describe azurerm_key_vault(resource_group: resource_group, vault_name: vault_name) do
    it          { should exist }
    its('name') { should eq vault_name }
    its('type') { should eq 'Microsoft.KeyVault/vaults' }
  end
end
