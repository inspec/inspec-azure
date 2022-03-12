resource_group = input('resource_group', value: nil)
factory_name = input('df_name', value: nil)
dataset_name = input('dataset_name', value: nil)
description = input('description', value: '')
linked_service_name = input('linked_service_name', value: nil)
dataset_type = input('dataset_type', value: nil)

control 'azure_data_factory_datasets' do

  impact 1.0
  title 'Testing the plural resource of azure_data_factory_datasets.'
  desc 'Testing the plural resource of azure_data_factory_datasets.'

  describe azure_data_factory_datasets(resource_group: resource_group, factory_name: factory_name) do
    it { should exist }
    its('names') { should include dataset_name }
    its('types') { should include dataset_type }
    its('descriptions') { should include description }
    its('linkedServiceName_referenceNames') { should include linked_service_name }
    its('linkedServiceName_types') { should include 'LinkedServiceReference' }
  end

  describe azure_data_factory_datasets(resource_group: resource_group, factory_name: 'fake') do
    it { should_not exist }
  end
end
