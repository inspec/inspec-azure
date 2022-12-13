resource_group = input(:resource_group, value: '')
project_name = input(:inspec_migrate_project_name, value: '')
name = 'inspec-migrate-test-assement'

control 'verify all azure migrate assessment machines in a project' do

  title 'Testing the plural resource of azure_migrate_assessment_machines.'
  desc 'Testing the plural resource of azure_migrate_assessment_machines.'

  describe azure_migrate_assessment_machines(resource_group: resource_group, project_name: project_name) do
    it { should exist }
    its('names') { should include name }
    its('types') { should include 'Microsoft.Migrate/assessmentprojects/machines' }
    its('bootTypes') { should include 'BIOS' }
    its('megabytesOfMemories') { should include 16384 }
    its('numberOfCores') { should include 8 }
  end
end
