resource_group = input('resource_group', value: "nirbhay-cosmos")
factory_name = input('factory_name', value: "test-samir-df")
run_id = input('run_id', value: "9e9e8b5c-2fee-4b1f-84e8-cb3ea8038b6a")
control 'azure_data_factory_pipeline_run_resource' do
  describe azure_data_factory_pipeline_run_resource(resource_group: resource_group, factory_name: factory_name, run_id: run_id) do
    it { should exist }
    its('invokedBy.name') { should eq 'Manual' }
    its('pipelineName') { should eq 'samir_delet_pipeline' }
    its('status') { should eq 'Failed' }
  end
end
