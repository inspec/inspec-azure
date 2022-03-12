control 'verify service emerging issues' do

  impact 1.0
  title 'Testing the plural resource of azure_resource_health_emerging_issues.'
  desc 'Testing the plural resource of azure_resource_health_emerging_issues.'

  describe azure_resource_health_emerging_issues do
    it { should exist }
    its('names') { should include 'default' }
    its('types') { should include '/providers/Microsoft.ResourceHealth/emergingissues' }
  end
end
