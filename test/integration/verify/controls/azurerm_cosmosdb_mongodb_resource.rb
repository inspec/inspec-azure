resource_group = attribute('resource_group', default: nil)
cosmosdb_database_account = attribute('cosmosdb_database_account', default: nil)
azurerm_cosmosdb_mongodb_resource = attribute('azurerm_cosmosdb_mongodb_resource', default: nil)

control 'azurerm_cosmosdb_mongodb_resource' do
  only_if { !cosmosdb_database_account.nil? }

  describe azurerm_cosmosdb_mongodb_resource(resource_group: resource_group, cosmosdb_database_account: cosmosdb_database_account, azurerm_cosmosdb_mongodb_resource: azurerm_cosmosdb_mongodb_resource) do
    its('name') { should eq cosmosdb_database_account }
    its('type') { should eq 'Microsoft.DocumentDB/databaseAccounts' }
  end

  describe azurerm_cosmosdb_mongodb_resource(resource_group: resource_group, cosmosdb_database_account: cosmosdb_database_account, azurerm_cosmosdb_mongodb_resource: azurerm_cosmosdb_mongodb_resource) do
    it { should_not exist }
  end
end
