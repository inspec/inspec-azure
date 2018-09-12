resource_group = attribute('resource_group', default: nil)
vault_name     = attribute('key_vault_name', default: nil)

control 'azurerm_key_vaults' do

  describe azurerm_key_vaults(resource_group: resource_group) do
    it           { should exist }
    its('names') { should include vault_name }
  end
end
