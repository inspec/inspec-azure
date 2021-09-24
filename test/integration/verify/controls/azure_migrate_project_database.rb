resource_group = input(:resource_group, value: '')
project_name = input(:project_name, value: 'inspec-migrate-integ')

control 'test the properties of an azure migrate project database' do
  describe azure_migrate_project_database(resource_group: resource_group, project_name: project_name, name: 'myDB') do
    it { should exist }
    its('name') { should eq 'mydb' }
    its('type') { should eq 'Microsoft.Migrate/MigrateProjects/Databases' }
    its('assessmentIds') { should include 'myassessment' }
    its('assessmentTargetTypes') { should include 'SQL' }
  end
end
