control "azure_graph_generic_resources" do
  title "Testing the plural resource of azure_graph_generic_resources."
  desc "Testing the plural resource of azure_graph_generic_resources."

  describe azure_graph_generic_resources(resource: "users", filter: { given_name: "John" }) do
    it { should exist }
  end
end
