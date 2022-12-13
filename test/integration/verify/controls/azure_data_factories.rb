resource_group = input('resource_group', value: nil)
factory_name = input('df_name', value: nil)
df_location = input('df_location', value: nil)

control 'azure_data_factories' do

  title 'Testing the plural resource of azure_data_factories.'
  desc 'Testing the plural resource of azure_data_factories.'

  describe azure_data_factories(resource_group: resource_group) do
    it { should exist }
    its('names') { should include factory_name }
    its('locations') { should include df_location }
    its('types') { should include 'Microsoft.DataFactory/factories' }
    its('provisioning_states') { should include('Succeeded') }
  end
end
