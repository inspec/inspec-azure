resource_group = input(:resource_group, value: '')
project_name = input(:inspec_migrate_project_name, value: '')
name = 'inspec-migrate-test-assement'

control 'verify all azure migrate assessments in a project' do

  impact 1.0
  title 'Testing the plural resource of azure_migrate_assessments.'
  desc 'Testing the plural resource of azure_migrate_assessments.'

  describe azure_migrate_assessments(resource_group: resource_group, project_name: project_name) do
    it { should exist }
    its('names') { should include name }
    its('types') { should include 'Microsoft.Migrate/assessmentprojects/groups/assessments' }
    its('azurePricingTiers') { should include 'Standard' }
    its('azureStorageRedundancies') { should include 'LocallyRedundant' }
    its('groupTypes') { should include 'Import' }
    its('scalingFactors') { should include 1.0 }
  end
end
