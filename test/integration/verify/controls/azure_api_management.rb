resource_group = input("resource_group", value: nil)
api_management_name = input("api_management_name", value: "")

control "azure_api_management" do
  title "Testing the singular resource of azure_api_management."
  desc "Testing the singular resource of azure_api_management."

  only_if { !api_management_name.empty? }

  describe azure_api_management(resource_group: resource_group, api_management_name: api_management_name) do
    it                { should exist }
    its("id")         { should_not be_nil }
    its("name")       { should eq api_management_name }
    its("location")   { should_not be_nil }
    its("type")       { should eq "Microsoft.ApiManagement/service" }
    its("properties.publisherEmail") { should eq "company@inspec.io" }
  end
end
