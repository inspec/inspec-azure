resource_group = input('resource_group', value: nil)
factory_name = input('df_name', value: nil)
gateways_name = input('gateways_name', value: nil)

control 'azure_data_factory_gateways' do
  describe azure_data_factory_gateways(resource_group: resource_group, factory_name: factory_name) do
    it { should exist }
    its('names') { should include gateways_name }
  end
end
