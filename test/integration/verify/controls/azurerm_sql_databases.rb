resource_group      = input("resource_group", value: nil)
sql_server_name     = input("sql_server_name", value: nil)
sql_server_database = input("sql_database_name", value: nil)

control "azurerm_sql_databases" do

  title "Testing the plural resource of azurerm_sql_databases."
  desc "Testing the plural resource of azurerm_sql_databases."

  only_if { !sql_server_database.nil? }

  describe azurerm_sql_databases(resource_group: resource_group, server_name: sql_server_name) do
    it           { should exist }
    its("names") { should include sql_server_database }
  end
end
