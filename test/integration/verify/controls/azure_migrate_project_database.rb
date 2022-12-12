resource_group = input(:resource_group, value: '')
project_name = input(:project_name, value: 'inspec-migrate-integ')

control 'Test the properties of an azure migrate project database' do

  title 'Testing the singular resource of azure_migrate_project_database.'
  desc 'Testing the singular resource of azure_migrate_project_database.'

  describe azure_migrate_project_database(resource_group: resource_group, project_name: project_name, name: 'myDB') do
    it { should exist }
    its('name') { should eq 'mydb' }
    its('type') { should eq 'Microsoft.Migrate/MigrateProjects/Databases' }
    its('assessmentIds') { should include 'myassessment' }
    its('assessmentTargetTypes') { should include 'SQL' }
  end
end
