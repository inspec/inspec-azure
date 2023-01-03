resource_group = input("resource_group", value: nil)
webapp_name = input("webapp_name", value: nil)

control "azure_webapps" do
  title "Testing the plural resource of azure_webapps."
  desc "Testing the plural resource of azure_webapps."

  describe azure_webapps(resource_group: resource_group) do
    it { should exist }
    its("names") { should include webapp_name }
  end
end
