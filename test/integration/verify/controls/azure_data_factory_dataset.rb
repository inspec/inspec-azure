resource_group = input('resource_group', value: nil)
factory_name = input('df_name', value: nil)
dataset_name = input('dataset_name', value: nil)
description = input('description', value: '')
linked_service_name = input('linked_service_name', value: nil)
dataset_type = input('dataset_type', value: nil)

control 'azure_data_factory_dataset' do

  impact 1.0
  title 'Testing the singular resource of azure_data_factory_dataset.'
  desc 'Testing the singular resource of azure_data_factory_dataset.'

  describe azure_data_factory_dataset(resource_group: resource_group, factory_name: factory_name, dataset_name: dataset_name) do
    it { should exist }
    its('name') { should eq dataset_name }
    its('type') { should eq 'Microsoft.DataFactory/factories/datasets' }
    its('properties.description') { should eq description }
    its('properties.type') { should eq dataset_type }
    its('properties.linkedServiceName.referenceName') { should eq linked_service_name }
    its('properties.linkedServiceName.type') { should eq 'LinkedServiceReference' }
  end
  describe azure_data_factory_dataset(resource_group: resource_group, factory_name: 'fake', dataset_name: dataset_name) do
    it { should_not exist }
  end
  describe azure_data_factory_dataset(resource_group: resource_group, factory_name: factory_name, dataset_name: 'fake') do
    it { should_not exist }
  end
end
