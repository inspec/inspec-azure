resource_group = input("resource_group", value: nil)
factory_name = input("df_name", value: nil)
df_location = input("df_location", value: nil)

control "azure_data_factory" do

  title "Testing the singular resource of azure_data_factory."
  desc "Testing the singular resource of azure_data_factory."

  describe azure_data_factory(resource_group: resource_group, name: factory_name) do
    it { should exist }
    its("name") { should eq factory_name }
    its("type") { should eq "Microsoft.DataFactory/factories" }
    its("provisioning_state") { should include("Succeeded") }
    its("location") { should include df_location }
  end

  describe azure_data_factory(resource_group: resource_group, name: "fake") do
    it { should_not exist }
  end

  describe azure_data_factory(resource_group: "fake", name: factory_name) do
    it { should_not exist }
  end
end
