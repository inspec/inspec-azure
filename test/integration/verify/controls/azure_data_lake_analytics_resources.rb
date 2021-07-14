resource_group = input('resource_group', value: nil)
account_name     = input('accountName', value: nil)

control 'azure_data_lake_analytics_resources' do
  describe azure_data_lake_analytics_resources(resource_group: resource_group) do
    its('names') { should include account_name }
    its('types') { should include 'Microsoft.DataLakeAnalytics/accounts'}
    its('provisioning_states') { should include('Succeeded') }
  end
end
