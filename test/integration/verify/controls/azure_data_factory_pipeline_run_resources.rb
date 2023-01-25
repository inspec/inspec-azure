# We dont have a terraform to check this resource. So this control should be checked manually.

skip_control "azure_data_factory_pipeline_run_resources" do
  title "Testing the plural resource of azure_data_factory_pipeline_run_resources."
  desc "Testing the plural resource of azure_data_factory_pipeline_run_resources."

  describe azure_data_factory_pipeline_run_resources(resource_group: "test", factory_name: "test") do
    it { should exist }
  end

  describe azure_data_factory_pipeline_run_resources(resource_group: "not-there", factory_name: "not-there") do
    it { should_not exist }
  end
end
