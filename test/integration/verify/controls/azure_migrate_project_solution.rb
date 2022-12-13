resource_group = input(:resource_group, value: '')
project_name = input(:project_name, value: 'inspec-migrate-integ')
name = input(:name, value: 'Servers-Assessment-ServerAssessment')

control 'Verify settings for Azure Migrate Project Solution' do

  title 'Testing the singular resource of azure_migrate_project_solution.'
  desc 'Testing the singular resource of azure_migrate_project_solution.'

  describe azure_migrate_project_solution(resource_group: resource_group, project_name: project_name, name: name) do
    it { should exist }
    its('name') { should eq name }
    its('type') { should eq 'Microsoft.Migrate/MigrateProjects/Solutions' }
    its('tool') { should eq 'ServerAssessment' }
  end
end
