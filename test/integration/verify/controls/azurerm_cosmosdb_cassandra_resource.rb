resource_group = attribute('resource_group', default: nil)
cosmosdb_database_account = attribute('cosmosdb_database_account', default: nil)
cosmosdb_cassandraKeyspaces_name = attribute('cosmosdb_cassandraKeyspaces_name', default: nil)
cosmosdb_table_name = attribute('cosmosdb_table_name', default: nil)

control 'azurerm_cosmosdb_cassandra_resource' do
  only_if { !cosmosdb_database_account.nil? }

  describe azurerm_cosmosdb_cassandra_resource( resource_group: resource_group,
                                              cosmosdb_database_account: cosmosdb_database_account, 
                                              cosmosdb_cassandraKeyspaces_name: cosmosdb_cassandraKeyspaces_name, 
                                              cosmosdb_table_name: cosmosdb_table_name) do
    its('name') { should eq cosmosdb_database_account }
    its('type') { should eq 'Microsoft.DocumentDB/databaseAccounts' }
  end

  describe azurerm_cosmosdb_cassandra_resource( resource_group: resource_group,
                                                cosmosdb_database_account: cosmosdb_database_account, 
                                                cosmosdb_cassandraKeyspaces_name: cosmosdb_cassandraKeyspaces_name, 
                                                cosmosdb_table_name: cosmosdb_table_name) do
    it { should_not exist }
  end
end
