resource_group = input('resource_group', value: 'nirbhay-cosmos')
factory_name = input('factory_name', value: 'test-samir-df')

control 'azure_data_factory_pipeline_run_resources' do
  describe azure_data_factory_pipeline_run_resources(resource_group: resource_group, factory_name: factory_name) do
    it { should exist }
    its('invokedBy_names') { should include 'Manual' }
    its('pipelineNames') { should include 'samir_delet_pipeline' }
    its('status') { should include 'Failed' }
  end
end
