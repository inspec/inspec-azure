control 'azure_sql_databases' do
  impact 1.0
  title 'Testing the plural resource of azure_sql_databases.'
  desc 'Testing the plural resource of azure_sql_databases.'

  describe azure_sql_databases(resource_group: 'samirdev', server_name: 'testsoumyoserver') do
    it { should exist }
  end

  describe azure_sql_databases(resource_group: 'samirdev', server_name: 'testsoumyoserver') do
    its('ids') { should include '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/samirdev/providers/Microsoft.Sql/servers/testsoumyoserver/databases/testdbsoumyo1' }
    its('names') { should include 'testdbsoumyo1' }
    its('types') { should include 'Microsoft.Sql/servers/databases' }
    its('locations') { should include 'eastus' }
  end
end
