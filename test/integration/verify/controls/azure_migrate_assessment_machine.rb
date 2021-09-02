resource_group = input(:resource_group, value: '')
project_name = input(:inspec_migrate_project_name, value: '')
# either way these are manual values since there is no terraform resource available
name = 'inspec-migrate-test-assement'

control 'verify a azure migrate assessment machine' do
  describe azure_migrate_assessment_machine(resource_group: resource_group, project_name: project_name, name: name) do
    it { should exist }
    its('name') { should eq name }
    its('type') { should eq 'Microsoft.Migrate/assessmentprojects/machines' }
    its('properties.bootType') { should eq 'BIOS' }
    its('properties.megabytesOfMemory') { should eq 16384 }
    its('properties.numberOfCores') { should eq 8 }
  end
end
