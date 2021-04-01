resource_group = attribute('resource_group', default: "nirbhay-cosmos")
cosmosdb_database_account = attribute('cosmosdb_database_account', default: "nirbhay1997cosmos1")
cosmosdb_mongodb_databases_name = attribute('cosmosdb_mongodb_databases_name', default: "testmongo")

control 'azure_cosmosdb_mongodb_resource' do
  #only_if { !cosmosdb_database_account.nil? }

  describe azure_cosmosdb_mongodb_resource(resource_group: resource_group, cosmosdb_database_account: cosmosdb_database_account, cosmosdb_mongodb_resource: cosmosdb_mongodb_databases_name) do
    its('name') { should eq cosmosdb_mongodb_databases_name }
    its('type') { should eq 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases' }
  end
end