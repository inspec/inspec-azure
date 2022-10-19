control 'azure_subnet' do
  impact 1.0
  title 'Testing the singular resource of azure_subnet.'
  desc 'Testing the singular resource of azure_subnet.'
  
  describe azure_subnet(resource_group: 'testsoumyorg', vnet: 'testvmsoumyo-nsg', name: 'default') do
    it { should exist }
    its('name') { should eq 'subnet-name' }
  end
  
  describe azure_subnet(resource_group: 'testsoumyorg', vnet: 'testvmsoumyo-nsg', name: 'default') do
    its('id') { should eq '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/samirdev/providers/Microsoft.Sql/servers/testsoumyoserver/databases/testdbsoumyo1' }
    its('name') { should eq 'default' }
    its('type') { should eq 'Microsoft.Sql/servers/databases' }
    its('location') { should eq 'eastus' }
  end
end
