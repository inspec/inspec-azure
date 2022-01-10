vault_name = input('key_vault_name', value: nil)
key_name   = input('key_vault_key_name', value: nil)

control 'azure_key_vault_key' do
  describe azure_key_vault_key(vault_name, key_name) do
    its('key.kid')    { should_not be_nil }
    its('attributes') { should have_attributes(enabled: true) }
  end
end
