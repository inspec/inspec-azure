resource_group = input("resource_group", value: nil)
api_management_name = input("api_management_name", value: "")

control "azure_api_managements" do

  title "Testing the plural resource of azure_api_managements."
  desc "Testing the plural resource of azure_api_managements."

  only_if { !api_management_name.empty? }
  describe azure_api_managements(resource_group: resource_group) do
    it           { should exist }
    its("names") { should include api_management_name }
  end

  describe azure_api_managements do
    it            { should exist }
    its("names")  { should include api_management_name }
  end
end
