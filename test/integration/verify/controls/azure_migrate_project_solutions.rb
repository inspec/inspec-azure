resource_group = input(:resource_group, value: '')
project_name = input(:project_name, value: 'inspec-migrate-integ')

control 'verify settings for Azure Migrate Project Solutions' do

  title 'Testing the plural resource of azure_migrate_project_solutions.'
  desc 'Testing the plural resource of azure_migrate_project_solutions.'

  describe azure_migrate_project_solutions(resource_group: resource_group, project_name: project_name) do
    it { should exist }
    its('names') { should include 'Servers-Assessment-ServerAssessment' }
    its('types') { should include 'Microsoft.Migrate/MigrateProjects/Solutions' }
    its('tools') { should include 'ServerAssessment' }
  end
end
