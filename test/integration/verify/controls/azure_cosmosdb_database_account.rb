resource_group = attribute('resource_group', default: nil)
cosmosdb_database_account = attribute('cosmosdb_database_account', default: nil)

control 'azure_cosmosdb_database_account' do
  only_if { !cosmosdb_database_account.nil? }

  describe azure_cosmosdb_database_account(resource_group: resource_group, cosmosdb_database_account: cosmosdb_database_account) do
    its('name') { should eq cosmosdb_database_account }
    its('type') { should eq 'Microsoft.DocumentDB/databaseAccounts' }
  end

  describe azure_cosmosdb_database_account(resource_group: resource_group, cosmosdb_database_account: 'fake') do
    it { should_not exist }
  end
end
