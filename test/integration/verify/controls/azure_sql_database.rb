control 'azure_sql_database' do
  impact 1.0
  title 'Testing the singular resource of azure_sql_database.'
  desc 'Testing the singular resource of azure_sql_database.'
  
  describe azure_sql_database(resource_group: 'samirdev', server_name: 'testsoumyoserver', name: 'testdbsoumyo1') do
    it { should exist }
  end
  
  describe azure_sql_database(resource_group: 'samirdev', server_name: 'testsoumyoserver', name: 'testdbsoumyo1') do
    its('id') { should eq '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/samirdev/providers/Microsoft.Sql/servers/testsoumyoserver/databases/testdbsoumyo1' }
    its('name') { should eq 'testdbsoumyo1' }
    its('type') { should eq 'Microsoft.Sql/servers/databases' }
    its('location') { should eq 'eastus' }
  end
end
