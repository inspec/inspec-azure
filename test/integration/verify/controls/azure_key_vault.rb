resource_group = input('resource_group', value: nil)
vault_name     = input('key_vault_name', value: nil)

control 'azure_key_vault' do

  impact 1.0
  title 'Testing the singular resource of azure_key_vault.'
  desc 'Testing the singular resource of azure_key_vault.'

  describe azure_key_vault(resource_group: resource_group, vault_name: vault_name) do
    it          { should exist }
    its('name') { should eq vault_name }
    its('type') { should eq 'Microsoft.KeyVault/vaults' }
  end

  describe azure_key_vault(resource_group: resource_group, vault_name: 'fake') do
    it { should_not exist }
  end

  describe azure_key_vault(resource_group: 'fake', vault_name: vault_name) do
    it { should_not exist }
  end
end
