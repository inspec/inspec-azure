vault_name = input("key_vault_name", value: nil)
secret_name = input("key_vault_secret_name", value: nil)

control "azure_key_vault_secret" do
  title "Testing the singular resource of azure_key_vault_secret."
  desc "Testing the singular resource of azure_key_vault_secret."

  describe azure_key_vault_secret(vault_name, secret_name) do
    it           { should exist }
    its("value") { should_not be_nil }
  end
end
