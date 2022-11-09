vault_name = input('key_vault_name', value: nil)
key_name   = input('key_vault_key_name', value: nil)

control 'azurerm_key_vault_key' do

  impact 1.0
  title 'Testing the singular resource of azurerm_key_vault_key.'
  desc 'Testing the singular resource of azurerm_key_vault_key.'

  describe azurerm_key_vault_key(vault_name, key_name) do
    its('key.kid')    { should_not be_nil }
    its('attributes') { should have_attributes(enabled: true) }
    its('rotation_policy') { should eq 0 }
  end
end
