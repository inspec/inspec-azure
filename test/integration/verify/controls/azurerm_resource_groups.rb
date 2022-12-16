resource_group = input("resource_group", value: nil)

# Added to test `inspec check` command
resource_group_names = azure_resource_groups.names

control "azurerm_resource_groups" do

  title "Testing the plural resource of azure_resource_groups."
  desc "Testing the plural resource of azure_resource_groups."

  describe azurerm_resource_groups do
    it { should exist }
    its("names") { should include(resource_group) }
    its("names.size") { should eq resource_group_names.size }
  end

  describe azurerm_resource_groups.where(name: resource_group) do
    its("tags.first") { should include("ExampleTag"=>"example") }
  end
end

control "azure_resource_groups_loop" do

  title "Testing the plural resource of azure_resource_groups."
  desc "Testing the plural resource of azure_resource_groups."

  azure_resource_groups.ids.each do |id|
    describe azure_resource_group(resource_id: id) do
      it { should exist }
    end
  end

  azure_resource_groups.names.each do |name|
    describe azure_resource_group(name: name) do
      it { should exist }
    end
  end

  describe azurerm_resource_groups do
    it { should_not exist }
  end
end
