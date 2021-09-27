resource_group = input(:resource_group, value: '')
project_name = input(:project_name, value: 'inspec-migrate-integ')

control 'test the properties of all azure migrate project events' do
  describe azure_migrate_project_events(resource_group: resource_group, project_name: project_name) do
    it { should exist }
    its('types') { should include 'Microsoft.Migrate/MigrateProjects/MigrateEvents' }
    its('instanceTypes') { should include 'Servers' }
  end
end
