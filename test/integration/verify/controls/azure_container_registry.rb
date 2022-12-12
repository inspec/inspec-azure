resource_group = attribute('resource_group', value: nil)
container_registry_name = attribute('container_registry_name', value: nil)

control 'azure_container_registry' do

  title 'Testing the singular resource of azure_container_registry.'
  desc 'Testing the singular resource of azure_container_registry.'

  describe azure_container_registry(resource_group: resource_group, name: container_registry_name) do
    it                { should exist }
    its('id')         { should_not be_nil }
    its('name')       { should eq container_registry_name }
    its('sku.name')   { should cmp 'Basic' }
    its('location')   { should_not be_nil }
  end
end
