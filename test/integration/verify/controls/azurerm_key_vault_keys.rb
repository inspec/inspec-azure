vault_name = input('key_vault_name', value: nil)

control 'azurerm_key_vault_keys' do

  azurerm_key_vault_keys(vault_name).entries.each do |key|
    describe key do
      its('kid')        { should_not be nil }
      its('attributes') { should have_attributes(enabled: true) }
    end
  end
end

control 'azure_key_vault_keys' do
  azure_key_vault_keys(vault_name).kids.each do |kid|
    describe azure_key_vault_key(key_id: kid) do
      it { should exist }
    end
  end
end
