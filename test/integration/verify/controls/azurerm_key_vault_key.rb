vault_name = attribute('key_vault_name', default: nil)
key_name   = attribute('key_vault_key_name', default: nil)

control 'azurerm_key_vault_key' do
  describe azurerm_key_vault_key(vault_name, key_name) do
    its('key.kid')    { should_not be_nil }
    its('attributes') { should have_attributes(enabled: true) }
  end
end
