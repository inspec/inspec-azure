resource_group = input('resource_group', value: nil)
account_name     = input('accountName', value: nil)
control 'azure_data_lake_analytics_resource' do
  describe azure_data_lake_analytics_resource(resource_group: resource_group, name: account_name) do
    it { should exist }
    its('name') { should eq account_name }
    its('type') { should eq 'Microsoft.DataLakeAnalytics/accounts' }
    its('provisioning_state') { should eq 'Succeeded' }
  end
end
