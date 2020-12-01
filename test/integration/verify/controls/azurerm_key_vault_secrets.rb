vault_name = input('key_vault_name', value: nil)

control 'azurerm_key_vault_secrets' do

  describe azurerm_key_vault_secrets(vault_name) do
    it { should exist }
  end
end

control 'azure_key_vault_secrets' do
  azure_key_vault_secrets(vault_name: vault_name).ids.each do |id|
    describe azure_key_vault_secret(secret_id: id) do
      it { should exist }
    end
  end
end
