resource_group = input(:resource_group, value: '')
project_name = input(:project_name, value: 'inspec-migrate-integ')

control 'test the properties of all azure migrate project database' do
  describe azure_migrate_project_databases(resource_group: resource_group, project_name: project_name) do
    it { should exist }
    its('names') { should include 'mydb' }
    its('types') { should include 'Microsoft.Migrate/MigrateProjects/Databases' }
    its('assessmentIds') { should include 'myassessment' }
    its('assessmentTargetTypes') { should include 'SQL' }
  end
end
