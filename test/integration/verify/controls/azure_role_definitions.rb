contributor_name = input("contributor_role_name", value: nil)

control "azure_role_definitions" do
  title "Testing the plural resource of azure_role_definitions."
  desc "Testing the plural resource of azure_role_definitions."

  describe azure_role_definitions.where(name: contributor_name) do
    its("names") { should include contributor_name }
    its("properties.first") { should have_attributes(roleName: "Contributor") }
    its("properties.first.permissions.first") { should have_attributes(actions: ["*"]) }
  end
end
