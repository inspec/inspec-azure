resource_group            = input('resource_group',        value: nil)
win_name                  = input('windows_vm_name',       value: nil)
win_id                    = input('windows_vm_id',         value: nil)
win_location              = input('windows_vm_location',   value: nil)
win_tags                  = input('windows_vm_tags',       value: nil)

control 'azure_generic_resource' do

  impact 1.0
  title 'Testing the singular resource of azure_generic_resource.'
  desc 'Testing the singular resource of azure_generic_resource.'

  describe azure_generic_resource(resource_group: resource_group, name: win_name) do
    it { should exist }
    its('id') { should cmp win_id }
    its('name') { should eq win_name }
    its('location') { should eq win_location }
    its('tags') { should eq win_tags }
    its('type') { should eq 'Microsoft.Compute/virtualMachines' }
    its('zones') { should be_nil }
  end

  describe azure_generic_resource(resource_uri: "/resourceGroups/#{resource_group}/providers/Microsoft.Compute/virtualMachines", name: win_name, add_subscription_id: true) do
    it { should exist }
    its('name') { should eq win_name }
  end

  describe azure_generic_resource(resource_provider: 'Microsoft.Compute/virtualMachines', resource_group: resource_group, name: win_name) do
    it { should exist }
  end

  # If api_version is not provided, latest version should be used.
  describe azure_generic_resource(resource_group: resource_group, name: win_name) do
    its('api_version_used_for_query_state') { should eq 'latest' }
  end

  # If supported by the resource type, the default api_version can be asked to use in the query.
  # If not supported, it will fall back to the latest api version.
  describe azure_generic_resource(resource_group: resource_group, name: win_name, api_version: 'default') do
    its('api_version_used_for_query_state') { should eq 'default' }
  end

  # Invalid api version issue should be handled and the latest version should be used.
  describe azure_generic_resource(resource_group: resource_group, name: win_name, api_version: 'invalid_api') do
    its('api_version_used_for_query_state') { should eq 'latest' }
  end

  # If valid api version is provided, this can be confirmed.
  describe azure_generic_resource(resource_group: resource_group, name: win_name, api_version: '2020-06-01') do
    its('api_version_used_for_query_state') { should eq 'user_provided' }
    its('api_version_used_for_query') { should eq '2020-06-01' }
  end

  describe azure_generic_resource(resource_group: resource_group, name: 'fake') do
    it { should_not exist }
  end

  describe azure_generic_resource(resource_group: 'fake', name: win_name) do
    it { should_not exist }
  end

  describe azure_generic_resource(resource_group: 'fake', name: 'fake') do
    it { should_not exist }
  end

  describe azure_generic_resource(resource_group: 'does-not-exist', name: win_name) do
    it { should_not exist }
  end

  describe azure_generic_resource(resource_group: resource_group, name: win_name) do
    its('properties.osProfile.linuxConfiguration.ssh') { should be_nil }
  end

  describe azure_generic_resource(resource_id: win_id) do
    its('name') { should eq win_name }
  end
end
