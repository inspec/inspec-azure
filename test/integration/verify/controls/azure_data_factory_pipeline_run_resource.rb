# We dont have a terraform to check this resource. So this control should be checked manually.

skip_control "azure_data_factory_pipeline_run_resource" do
  title "Testing the singular resource of azure_data_factory_pipeline_run_resource."
  desc "Testing the singular resource of azure_data_factory_pipeline_run_resource."

  describe azure_data_factory_pipeline_run_resource(resource_group: 'test', factory_name: 'test', run_id: '0448d45a-a0bd-23f3-90a5-bfeea9264aed') do
    it { should exist }
  end

  describe azure_data_factory_pipeline_run_resource(resource_group: 'not-there', factory_name: 'not-there', run_id: 'not-there') do
    it { should_not exist }
  end
end
