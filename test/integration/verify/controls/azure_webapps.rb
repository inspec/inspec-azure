control 'azure_webapps' do
  impact 1.0
  title 'Testing the plural resource of azure_webapps.'
  desc 'Testing the plural resource of azure_webapps.'

  describe azure_webapps(resource_group: 'rgsoumyo') do
    its('ids') { should include '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/rgsoumyo/providers/Microsoft.Web/sites/wasoumyo' }
    its('names') { should include 'wasoumyo' }
    its('types') { should include 'Microsoft.Web/sites' }
    its('kinds') { should include 'app,linux' }
    its('locations') { should include 'East US' }
  end
end
