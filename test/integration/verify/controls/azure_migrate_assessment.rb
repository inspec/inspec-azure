resource_group = input(:resource_group, value: '')
project_name = input(:inspec_migrate_project_name, value: '')
# either way these are manual values since there is no terraform resource available
group_name = 'inspec-migrate-test-assement-group'
name = 'inspec-migrate-test-assement'

control 'verify a azure migrate assessment' do

  title 'Testing the singular resource of azure_migrate_assessment.'
  desc 'Testing the singular resource of azure_migrate_assessment.'

  describe azure_migrate_assessment(resource_group: resource_group, project_name: project_name, group_name: group_name, name: name) do
    it { should exist }
    its('name') { should eq name }
    its('type') { should eq 'Microsoft.Migrate/assessmentprojects/groups/assessments' }
    its('properties.azurePricingTier') { should eq 'Standard' }
    its('properties.azureStorageRedundancy') { should eq 'LocallyRedundant' }
    its('properties.groupType') { should eq 'Import' }
    its('properties.scalingFactor') { should eq 1.0 }
  end
end
