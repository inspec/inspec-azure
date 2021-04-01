resource_group = attribute('resource_group', default: "nirbhay-cosmos")
cosmosdb_database_account = attribute('cosmosdb_database_account', default: "nirbhay1997cosmos")
cosmosdb_sql_databasename = attribute('cosmosdb_sql_databasename', default: "SampleDB")
cosmosdb_containername = attribute('cosmosdb_containername', default: "Persons")
control 'azurerm_cosmosdb_sql_resource' do
  #only_if { !cosmosdb_database_account.nil? }
  describe azurerm_cosmosdb_sql_resource( resource_group: resource_group,
                                        cosmosdb_database_account: cosmosdb_database_account,
                                        cosmosdb_sql_databasename: cosmosdb_sql_databasename,
                                        cosmosdb_containername: cosmosdb_containername) do
    its('name') { should eq cosmosdb_database_account }
    its('type') { should eq 'Microsoft.DocumentDB/databaseAccounts' }
  end
  # describe azure_cosmosdb_sql_resource(resource_group: resource_group,
  #                                      cosmosdb_database_account: cosmosdb_database_account,
  #                                      cosmosdb_sql_databasename: cosmosdb_sql_databasename,
  #                                      cosmosdb_containername: cosmosdb_containername) do
  #   it { should_not exist }
  # end
end