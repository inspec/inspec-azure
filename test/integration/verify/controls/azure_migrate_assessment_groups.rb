resource_group = input(:resource_group, value: '')
project_name = input(:inspec_migrate_project_name, value: '')
name = 'inspec-migrate-test-assement-group'

control 'verify all azure migrate assessments in a project' do

  title 'Testing the plural resource of azure_migrate_assessment_groups.'
  desc 'Testing the plural resource of azure_migrate_assessment_groups.'

  describe azure_migrate_assessment_groups(resource_group: resource_group, project_name: project_name) do
    it { should exist }
    its('names') { should include name }
    its('types') { should include 'Microsoft.Migrate/assessmentprojects/groups' }
  end
end
