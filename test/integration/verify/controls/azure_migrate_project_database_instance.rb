resource_group = input(:resource_group, value: '')
project_name = input(:project_name, value: 'inspec-migrate-integ')

control 'test the properties of an azure migrate project database' do
  describe azure_migrate_project_database_instance(resource_group: resource_group, project_name: project_name, name: 'my_db_instance') do
    it { should exist }
    its('name') { should eq 'my_db_instance' }
    its('type') { should eq 'Microsoft.Migrate/MigrateProjects/DatabaseInstances' }
    its('instanceIds') { should include 'instance-1' }
    its('instanceTypes') { should include 'SQL' }
  end
end
