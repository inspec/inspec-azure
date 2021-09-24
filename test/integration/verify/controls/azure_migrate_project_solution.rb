resource_group = input(:resource_group, value: '')
project_name = input(:project_name, value: 'inspec-migrate-integ')
name = input(:name, value: 'Servers-Assessment-ServerAssessment')

control 'verify settings for Azure Migrate Project Solution' do
  describe azure_migrate_project_solution(resource_group: resource_group, project_name: project_name, name: name) do
    it { should exist }
    its('name') { should eq name }
    its('type') { should eq 'Microsoft.Migrate/MigrateProjects/Solutions' }
    its('tool') { should eq 'ServerAssessment' }
  end
end
