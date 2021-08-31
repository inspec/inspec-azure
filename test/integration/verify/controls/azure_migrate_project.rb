resource_group = input(:resource_group, value: '')
project_name = input(:project_name, value: 'inspec-migrate-integ')

control 'test the properties of an azure migrate project' do
  describe azure_migrate_project(resource_group: resource_group, name: project_name) do
    it { should exist }
    its('name') { should eq project_name }
    its('type') { should eq 'Microsoft.Migrate/MigrateProjects' }
    its('properties.registeredTools') { should include 'ServerAssessment' }
    its('properties.summary.servers.instanceType') { should eq 'Servers' }
  end
end
