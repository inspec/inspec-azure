resource_group = input("resource_group", value: "", description: "")
factory_name = input("df_name", value: "", description: "")
linked_service_name = input("linked_service_name", value: "", description: "")
linked_service_id = input("linked_service_id", value: "", description: "")

control "azure_data_factory_linked_services" do
  title "Testing the plural resource of azure_data_factory_linked_services."
  desc "Testing the plural resource of azure_data_factory_linked_services."
  
  describe azure_data_factory_linked_services(resource_group: resource_group, factory_name: factory_name) do
    it { should exist }
  end
  
  describe azure_data_factory_linked_services(resource_group: resource_group, factory_name: factory_name) do
    its("names") { should include linked_service_name }
    its("types") { should include "Microsoft.DataFactory/factories/linkedservices" }
    its("ids") { should include linked_service_id }
    its("properties") { should_not be_empty }
  end
  
  describe azure_data_factory_linked_services(resource_group: resource_group, factory_name: "not-there") do
    it { should_not exist }
  end
end
