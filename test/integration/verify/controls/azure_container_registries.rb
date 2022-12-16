resource_group = attribute("resource_group", value: nil)
container_registry_name = attribute("container_registry_name", value: nil)

control "azure_container_registries" do

  title "Testing the plural resource of azure_container_registries."
  desc "Testing the plural resource of azure_container_registries."

  describe azure_container_registries(resource_group: resource_group) do
    it           { should exist }
    its("names") { should include container_registry_name }
  end

  describe azure_container_registries do
    it            { should exist }
    its("names")  { should include container_registry_name }
  end
end
