resource_group = input('resource_group', value: nil)

control 'azure_resource_group' do

  impact 1.0
  title 'Testing the singular resource of azure_resource_group.'
  desc 'Testing the singular resource of azure_resource_group.'

  describe azure_resource_group(name: resource_group) do
    its('tags') { should include('ExampleTag'=>'example') }
  end
end
