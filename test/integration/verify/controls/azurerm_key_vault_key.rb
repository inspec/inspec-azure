vault_name = attribute('key_vault_name', default: nil)
key_name   = attribute('key_vault_key_name', default: nil)

control 'azurerm_key_vault_key' do

    azurerm_key_vault_key(vault_name, key_name) do |key|
      describe key do
        its('key.kid')            { should_not be_nil }
        its('attributes.enabled') { should eq false }
      end
    end
end
