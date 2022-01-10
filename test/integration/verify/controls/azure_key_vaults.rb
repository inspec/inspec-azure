resource_group = input('resource_group', value: nil)
vault_name     = input('key_vault_name', value: nil)

control 'azure_key_vaults' do

  describe azure_key_vaults(resource_group: resource_group) do
    it           { should exist }
    its('names') { should include vault_name }
  end
end

control 'azure_key_vaults' do
  impact 1.0
  title 'Ensure that azure_key_vaults plural resource works without a parameter.'

  azure_key_vaults.ids.each do |id|
    describe azure_key_vault(resource_id: id) do
      its('type') { should eq 'Microsoft.KeyVault/vaults' }
    end
  end
end
