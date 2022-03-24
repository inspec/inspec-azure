resource_group1 = input('resource_group', value: nil)
factory_name1 = input('df_name', value: nil)
linked_service_name1 = input('linked_service_name', value: nil)

control 'azure_data_factory_linked_service' do

  impact 1.0
  title 'Testing the singular resource of azure_data_factory_linked_service.'
  desc 'Testing the singular resource of azure_data_factory_linked_service.'

  describe azure_data_factory_linked_service(resource_group: resource_group1,
                                             factory_name: factory_name1, linked_service_name: linked_service_name1) do
    it { should exist }
    its('name') { should eq linked_service_name1 }
    its('type') { should eq 'Microsoft.DataFactory/factories/linkedservices' }
    its('linked_service_type') { should eq 'MySql' }
  end

  describe azure_data_factory_linked_service(resource_group: resource_group1,
                                             factory_name: 'fake', linked_service_name: linked_service_name1) do
    it { should_not exist }
  end

  describe azure_data_factory_linked_service(resource_group: resource_group1,
                                             factory_name: factory_name1, linked_service_name: 'should_not_exist') do
    it { should_not exist }
  end
end
