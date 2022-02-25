resource_group = input(:resource_group, value: '')
project_name = input(:project_name, value: 'inspec-migrate-integ')

control 'test the properties of all azure migrate project database' do
  describe azure_migrate_project_database_instances(resource_group: resource_group, project_name: project_name) do
    it { should exist }
    its('names') { should include 'my_db_instance' }
    its('types') { should include 'Microsoft.Migrate/MigrateProjects/DatabaseInstances' }
    its('instanceIds') { should include 'instance-1' }
    its('instanceTypes') { should include 'SQL' }
  end
end
