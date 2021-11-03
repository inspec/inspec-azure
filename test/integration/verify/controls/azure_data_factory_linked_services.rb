resource_group = input('resource_group', value: nil)
factory_name = input('df_name', value: nil)
linked_service_name1 = input('linked_service_name', value: nil)

control 'azure_data_factory_linked_services' do
  describe azure_data_factory_linked_services(resource_group: resource_group, factory_name: factory_name) do
    it { should exist }
    its('names') { should include linked_service_name1 }
    its('types') { should include 'Microsoft.DataFactory/factories/linkedservices' }
    its('linked_service_types') { should include('MySql') }
  end
end
