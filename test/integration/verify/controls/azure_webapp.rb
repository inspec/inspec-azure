resource_group = input("resource_group", value: nil)
webapp_name = input("webapp_name", value: nil)

control "azure_webapp" do
  title "Testing the singular resource of azure_webapp."
  desc "Testing the singular resource of azure_webapp."

  describe azure_webapp(resource_group: resource_group, name: webapp_name) do
    it                { should have_identity }
    it                { should be_using_latest("aspnet") }
    its("properties") { should have_attributes(httpsOnly: true) }
  end
end
