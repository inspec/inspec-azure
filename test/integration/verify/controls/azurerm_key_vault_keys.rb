vault_name = attribute('key_vault_name', default: nil)

control 'azurerm_key_vault_keys' do

  describe azurerm_key_vault_keys(vault_name) do
  it { should exist }
  end
end
