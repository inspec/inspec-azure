control 'azure_mariadb_server' do
  impact 1.0
  title 'Testing the singular resource of azure_mariadb_server.'
  desc 'Testing the singular resource of azure_mariadb_server.'

  describe azure_mariadb_server(resource_group: 'rgsoumyo', name: 'mdbserver') do
    it { should exist }
  end

  describe azure_mariadb_server(resource_group: 'rgsoumyo', name: 'mdbserver') do
    its('id') { should eq '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/rgsoumyo/providers/Microsoft.DBforMariaDB/servers/mdbsoumyo' }
    its('name') { should eq 'mdbsoumyo' }
    its('location') { should eq 'eastus' }
    its('type') { should eq 'Microsoft.DBforMariaDB/servers' }
    its('tags') { should be_empty }
  end
end
