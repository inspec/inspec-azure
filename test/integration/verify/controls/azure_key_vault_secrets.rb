vault_name = input("key_vault_name", value: nil)

control "azure_key_vault_secrets" do
  title "Testing the plural resource of azure_key_vault_secrets."
  desc "Testing the plural resource of azure_key_vault_secrets."

  describe azure_key_vault_secrets(vault_name) do
    it { should exist }
  end

  azure_key_vault_secrets(vault_name: vault_name).ids.each do |id|
    describe azure_key_vault_secret(secret_id: id) do
      it { should exist }
    end
  end
end
