vault_name = input("key_vault_name", value: nil)
key_name   = input("key_vault_key_name", value: nil)

control "azure_key_vault_key" do

  title "Testing the singular resource of azure_key_vault_key."
  desc "Testing the singular resource of azure_key_vault_key."

  describe azure_key_vault_key(vault_name, key_name) do
    its("key.kid")    { should_not be_nil }
    its("attributes") { should have_attributes(enabled: true) }
    it { should have_rotation_policy_enabled }
  end
end
