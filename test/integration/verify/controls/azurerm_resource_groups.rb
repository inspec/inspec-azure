resource_group = input('resource_group', value: nil)

control 'azurerm_resource_groups' do
  describe azurerm_resource_groups do
    it                 { should exist }
    its('names')       { should include(resource_group) }
  end

  describe azurerm_resource_groups.where(name: resource_group) do
    its('tags.first') { should include('ExampleTag'=>'example') }
  end
end

control 'azure_resource_groups_loop' do
  azure_resource_groups.ids.each do |id|
    describe azure_resource_group(resource_id: id) do
      it { should exist }
    end
  end
  azure_resource_groups.names.each do |name|
    describe azure_resource_group(name: name) do
      it { should exist }
    end
  end
end
