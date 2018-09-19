vault_name = attribute('key_vault_name', default: nil)

control 'azurerm_key_vault_keys' do

  azurerm_key_vault_keys(vault_name).entries.each do |key|
    describe key do
      its('kid')                { should_not be nil }
      its('attributes.enabled') { should eq true }
    end
  end
end
