control "azure_graph_generic_resource" do

  title "Testing the singular resource of azure_graph_generic_resource."
  desc "Testing the singular resource of azure_graph_generic_resource."

  user_id = azure_graph_users.user_principal_names.sample
  describe azure_graph_generic_resource(resource: "users", id: user_id) do
    it { should exist }
    its("userPrincipalName") { should eq user_id }
  end
end
