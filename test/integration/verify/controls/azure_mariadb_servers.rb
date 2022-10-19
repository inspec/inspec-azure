control 'azure_mariadb_servers' do
  impact 1.0
  title 'Testing the plural resource of azure_mariadb_servers.'
  desc 'Testing the plural resource of azure_mariadb_servers.'
  
  describe azure_mariadb_servers do
    it { should exist }
  end
  
  describe azure_mariadb_servers do
    its('ids') { should include '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/rgsoumyo/providers/Microsoft.DBforMariaDB/servers/mdbsoumyo' }
    its('names') { should include 'mdbsoumyo' }
    its('locations') { should include 'eastus' }
    its('types') { should include 'Microsoft.DBforMariaDB/servers' }
  end
end
