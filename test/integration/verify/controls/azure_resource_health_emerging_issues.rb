control 'verify service emerging issues' do
  describe azure_resource_health_emerging_issues do
    it { should exist }
    its('names') { should include 'default' }
    its('types') { should include '/providers/Microsoft.ResourceHealth/emergingissues' }
  end
end
