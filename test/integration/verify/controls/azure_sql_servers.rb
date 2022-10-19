control 'azure_sql_servers' do
  impact 1.0
  title 'Testing the plural resource of azure_sql_servers.'
  desc 'Testing the plural resource of azure_sql_servers.'

  describe azure_sql_servers do
    it { should exist }
  end

  describe azure_sql_servers do
    its('ids') { should include '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/samirdev/providers/Microsoft.Sql/servers/testsoumyoserver' }
    its('names') { should include 'testsoumyoserver' }
    its('types') { should include 'Microsoft.Sql/servers' }
    its('locations') { should include 'eastus' }
  end
end
