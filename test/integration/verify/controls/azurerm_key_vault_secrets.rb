vault_name = attribute('key_vault_name', value: nil)

control 'azurerm_key_vault_secrets' do

  describe azurerm_key_vault_secrets(vault_name) do
    it { should exist }
  end
end
