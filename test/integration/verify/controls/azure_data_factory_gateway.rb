resource_group = input('resource_group', value: nil)
factory_name = input('df_name', value: nil)
gateways_name = input('gateways_name', value: nil)
control 'azure_data_factory_gateway' do
  describe azure_data_factory_gateway(resource_group: resource_group, factory_name: factory_name, gateways_name: gateways_name) do
    it { should exist }
    its('name') { should eq gateways_name }
  end

  describe azure_data_factory_gateway(resource_group: resource_group, factory_name: 'fake', gateways_name: gateways_name) do
    it { should_not exist }
  end

  describe azure_data_factory_gateway(resource_group: 'fake', factory_name: factory_name, gateways_name: gateways_name) do
    it { should_not exist }
  end
end
