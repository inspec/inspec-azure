resource_group = input('resource_group', value: nil)

control 'azure_resource_group' do
  describe azure_resource_group(name: resource_group) do
    its('tags') { should include('ExampleTag'=>'example') }
  end
end
