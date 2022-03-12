resource_group = input('resource_group', value: nil)
incident_id = input('incident_id', value: nil)
workspace_name = input('workspace_name', value: nil)

control 'azure_sentinel_incidents_resource' do

  impact 1.0
  title 'Testing the singular resource of azure_sentinel_incidents_resource.'
  desc 'Testing the singular resource of azure_sentinel_incidents_resource.'

  describe azure_sentinel_incidents_resource(resource_group: resource_group, workspace_name: workspace_name, incident_id: incident_id) do
    it { should exist }
    its('type') { should eq 'Microsoft.OperationalInsights/workspaces' }
    its('severity') { should include 'Informational' }
    its('title') { should include 'test-ana' }
    its('status') { should include 'new' }
    its('owner.email') { should include 'samir.anand@progress.com' }
    its('owner.userPrincipalName') { should include 'samir.anand@progress.com' }
    its('owner.assignedTo') { should include 'Samir Anand' }
  end

  describe azure_sentinel_incidents_resource(resource_group: resource_group, workspace_name: workspace_name, incident_id: incident_id) do
    it { should_not exist }
  end

  describe azure_sentinel_incidents_resource(resource_group: resource_group, workspace_name: workspace_name, incident_id: incident_id) do
    it { should_not exist }
  end
end
