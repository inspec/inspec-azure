vault_name = attribute('key_vault_name', default: nil)
secret_name = attribute('key_vault_secret_name', default: nil)

control 'azurerm_key_vault_secret' do
  describe azurerm_key_vault_secret(vault_name, secret_name) do
    it           { should exist }
    its('value') { should_not be_nil }
  end
end
