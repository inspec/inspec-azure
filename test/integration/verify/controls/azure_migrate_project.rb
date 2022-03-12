resource_group = input(:resource_group, value: '')
project_name = input(:project_name, value: 'inspec-migrate-integ')

control 'Test the properties of an azure migrate project' do

  impact 1.0
  title 'Testing the singular resource of azure_migrate_project.'
  desc 'Testing the singular resource of azure_migrate_project.'

  describe azure_migrate_project(resource_group: resource_group, name: project_name) do
    it { should exist }
    its('name') { should eq project_name }
    its('type') { should eq 'Microsoft.Migrate/MigrateProjects' }
    its('properties.registeredTools') { should include 'ServerAssessment' }
    its('properties.summary.servers.instanceType') { should eq 'Servers' }
  end
end
