# #GetGremlinDatabase https://docs.microsoft.com/en-us/rest/api/cosmos-db-resource-provider/2020-04-01/gremlinresources/getgremlindatabase
resource_group = attribute('resource_group', default: "Group-620")
cosmosdb_database_account = attribute('cosmosdb_database_account', default: "cosmos-620")
cosmodb_gremlinDatabase_name = attribute('cosmodb_gremlinDatabase_name', default: "database1")

control 'azure_cosmosdb_gremlin_resource' do
  # only_if { !cosmosdb_database_account.nil? }

  describe azure_cosmosdb_gremlin_resource(resource_group: resource_group, cosmosdb_database_account: cosmosdb_database_account, cosmodb_gremlinDatabase_name: cosmodb_gremlinDatabase_name) do
    its('name') { should eq cosmodb_gremlinDatabase_name }
    its('type') { should eq 'Microsoft.DocumentDB/databaseAccounts/gremlinDatabases' }
  end
end