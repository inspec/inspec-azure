control 'verify default emerging issue for services' do
  describe azure_resource_health_emerging_issue(name: 'default') do
    it { should exist }
    its('name') { should eq 'default' }
    its('type') { should eq '/providers/Microsoft.ResourceHealth/emergingissues' }
    its('properties.statusActiveEvents') { should be_empty }
  end
end
