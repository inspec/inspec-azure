control 'azure_subnets' do
  impact 1.0
  title 'Testing the plural resource of azure_subnets.'
  desc 'Testing the plural resource of azure_subnets.'

  describe azure_subnets(resource_group: 'testsoumyorg', vnet: 'testvmsoumyo-nsg') do
    it { should exist }
  end

  describe azure_subnets(resource_group: 'testsoumyorg', vnet: 'testvmsoumyo-nsg') do
    its('ids') { should include '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/samirdev/providers/Microsoft.Sql/servers/testsoumyoserver/databases/testdbsoumyo1' }
    its('names') { should include 'default' }
    its('types') { should include 'Microsoft.Sql/servers/databases' }
    its('locations') { should include 'eastus' }
  end
end
