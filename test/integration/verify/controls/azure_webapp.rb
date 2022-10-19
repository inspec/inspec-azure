control 'azure_webapp' do
  impact 1.0
  title 'Testing the singular resource of azure_webapp.'
  desc 'Testing the singular resource of azure_webapp.'
  
  describe azure_webapp(resource_group: 'rgsoumyo', name: 'wasoumyo') do
    it { should exist }
  end
  
  describe azure_webapp(resource_group: 'rgsoumyo', name: 'wasoumyo') do
    its('id') { should eq '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/rgsoumyo/providers/Microsoft.Web/sites/wasoumyo' }
    its('name') { should eq 'wasoumyo' }
    its('type') { should eq 'Microsoft.Web/sites' }
    its('kind') { should eq 'app,linux' }
    its('location') { should eq 'East US' }
    its('properties.name') { should eq 'wasoumyo' }
    its('properties.state') { should eq 'Running' }
    its('properties.hostNames') { should include 'wasoumyo.azurewebsites.net' }
  end
end
