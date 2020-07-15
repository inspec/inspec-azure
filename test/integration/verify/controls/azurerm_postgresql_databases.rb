resource_group = input("resource_group", value: nil)
postgresql_server_name = input("postgresql_server_name", value: nil)
postgresql_database_name = input("postgresql_database_name", value: nil)

control "azurerm_postgresql_databases" do
  only_if { ENV["SQL"] }

  describe azurerm_postgresql_databases(resource_group: resource_group, server_name: postgresql_server_name) do
    it           { should exist }
    its("names") { should include postgresql_database_name }
  end
end
