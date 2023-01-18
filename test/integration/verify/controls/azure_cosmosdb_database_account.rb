resource_group = input("resource_group", value: nil)
cosmosdb_database_account = input("cosmosdb_database_account", value: nil)

control "azure_cosmosdb_database_account" do

  title "Testing the singular resource of azure_cosmosdb_database_account."
  desc "Testing the singular resource of azure_cosmosdb_database_account."

  only_if { !cosmosdb_database_account.nil? }

  describe azure_cosmosdb_database_account(resource_group: resource_group, cosmosdb_database_account: cosmosdb_database_account) do
    its("name") { should eq cosmosdb_database_account }
    its("type") { should eq "Microsoft.DocumentDB/databaseAccounts" }
  end

  describe azure_cosmosdb_database_account(resource_group: resource_group, cosmosdb_database_account: "fake") do
    it { should_not exist }
  end
end
