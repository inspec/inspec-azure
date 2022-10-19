control 'azure_sql_server' do
  impact 1.0
  title 'Testing the singular resource of azure_sql_server.'
  desc 'Testing the singular resource of azure_sql_server.'
  
  describe azure_sql_server(resource_group: 'samirdev', name: 'testsoumyoserver') do
    it { should exist }
  end
  
  describe azure_sql_server(resource_group: 'samirdev', name: 'testsoumyoserver') do
    its('id') { should eq '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/samirdev/providers/Microsoft.Sql/servers/testsoumyoserver' }
    its('name') { should eq 'testsoumyoserver' }
    its('type') { should eq 'Microsoft.Sql/servers' }
    its('location') { should eq 'eastus' }
  end
end
