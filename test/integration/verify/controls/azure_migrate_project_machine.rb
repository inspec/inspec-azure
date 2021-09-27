resource_group = input(:resource_group, value: '')
project_name = input(:project_name, value: 'inspec-migrate-integ')
machine_name = 'c042be9e-3d93-42cf-917f-b92c68318ded'

control 'test the properties of an azure migrate project machine' do
  describe azure_migrate_project_machines(resource_group: resource_group, project_name: project_name, name: machine_name) do
    it { should exist }
    its('types') { should include 'Microsoft.Migrate/MigrateProjects/Machines' }
    its('properties.discoveryData') { should_not be_empty }
    its('properties.discoveryData.first') { should include({ osType: 'windowsguest' }) }
  end
end
