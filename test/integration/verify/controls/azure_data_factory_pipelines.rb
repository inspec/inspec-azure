resource_group = input("resource_group", value: nil)
factory_name = input("df_name", value: nil)
pipelines_name = input("df_pipeline_name", value: nil)

control "azure_data_factory_pipelines" do

  title "Testing the plural resource of azure_data_factory_pipelines."
  desc "Testing the plural resource of azure_data_factory_pipelines."

  describe azure_data_factory_pipelines(resource_group: resource_group, factory_name: factory_name) do
    it { should exist }
    its("names") { should include pipelines_name }
    its("types") { should include "Microsoft.DataFactory/factories/pipelines" }
  end
end
