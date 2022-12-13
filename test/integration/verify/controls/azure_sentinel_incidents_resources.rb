resource_group = input('resource_group', value: nil)
incident_name = input('incident_name', value: nil)
workspace_name = input('workspace_name', value: nil)

control 'azure_sentinel_incidents_resources' do

  title 'Testing the plural resource of azure_sentinel_incidents_resources.'
  desc 'Testing the plural resource of azure_sentinel_incidents_resources.'

  describe azure_sentinel_incidents_resources(resource_group: resource_group, workspace_name: workspace_name) do
    it { should exist }
    its('names') { should include incident_name }
    its('types') { should include 'Microsoft.OperationalInsights/workspaces' }
    its('severity') { should include 'High' }
    its('classification') { should include 'High' }
    its('classificationComment') { should include 'High' }
    its('classificationReason') { should include 'Closed' }
    its('status') { should include 'Closed' }
    its('owner.objectId') { should include 'Closed' }
    its('owner.email') { should include 'Closed' }
    its('owner.userPrincipalName') { should include 'Closed' }
    its('owner.assignedTo') { should include 'Closed' }
    its('owner.assignedTo') { should include 'incidentNumber' }
  end
end
