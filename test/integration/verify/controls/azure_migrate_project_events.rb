resource_group = input(:resource_group, value: '')
project_name = input(:project_name, value: 'inspec-migrate-integ')

control 'test the properties of all azure migrate project events' do

  title 'Testing the plural resource of azure_migrate_project_events.'
  desc 'Testing the plural resource of azure_migrate_project_events.'

  describe azure_migrate_project_events(resource_group: resource_group, project_name: project_name) do
    it { should exist }
    its('types') { should include 'Microsoft.Migrate/MigrateProjects/MigrateEvents' }
    its('instanceTypes') { should include 'Servers' }
  end
end
