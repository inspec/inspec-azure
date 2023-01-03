resource_group  = input("resource_group", value: nil)
sql_server_name = input("sql_server_name", value: nil)

control "azure_sql_servers" do
  title "Testing the plural resource of azure_sql_servers."
  desc "Testing the plural resource of azure_sql_servers."

  only_if { !sql_server_name.nil? }

  describe azure_sql_servers(resource_group: resource_group) do
    it { should exist }
    its("names") { should include sql_server_name }
  end

  azure_sql_servers.ids.each do |id|
    describe azure_sql_server(resource_id: id) do
      it { should exist }
    end
  end
end
