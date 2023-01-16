resource_group = input("resource_group", value: nil)
mysql_server_name = input("mysql_server_name", value: nil)
mysql_db_name = input("mysql_database_name", value: nil)

control "azurerm_mysql_database" do

  title "Testing the singular resource of azurerm_mysql_database."
  desc "Testing the singular resource of azurerm_mysql_database."

  only_if { !mysql_db_name.nil? }
  describe azurerm_mysql_database(resource_group: resource_group,
                                  server_name: mysql_server_name,
                                  database_name: mysql_db_name) do
                                    it { should exist }
                                    its("id")       { should_not be_nil }
                                    its("name")     { should eq mysql_db_name }
                                    its("type")     { should eq "Microsoft.DBforMySQL/servers/databases" }
                                  end
end
