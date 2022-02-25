resource_group = attribute('resource_group', default: nil)
cosmosdb_database_account = attribute('cosmosdb_database_account', default: nil)

control 'azurerm_cosmosdb_database_account' do

  impact 1.0
  title 'Testing the singular resource of azurerm_cosmosdb_database_account.'
  desc 'Testing the singular resource of azurerm_cosmosdb_database_account.'

  only_if { !cosmosdb_database_account.nil? }

  describe azurerm_cosmosdb_database_account(resource_group: resource_group, cosmosdb_database_account: cosmosdb_database_account) do
    its('name') { should eq cosmosdb_database_account }
    its('type') { should eq 'Microsoft.DocumentDB/databaseAccounts' }
  end

  describe azurerm_cosmosdb_database_account(resource_group: resource_group, cosmosdb_database_account: 'fake') do
    it { should_not exist }
  end
end
