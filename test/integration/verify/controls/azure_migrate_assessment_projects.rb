location = input(:location, value: '')

control 'Verifies settings for a collection of Azure Migrate Assessment Projects' do

  impact 1.0
  title 'Testing the plural resource of azure_migrate_assessment_projects.'
  desc 'Testing the plural resource of azure_migrate_assessment_projects.'

  describe azure_migrate_assessment_projects do
    it { should exist }
    its('locations') { should include location }
    its('publicNetworkAccesses') { should include 'Enabled' }
    its('numberOfGroups') { should include '1' }
    its('numberOfMachines') { should include 10 }
    its('numberOfImportMachines') { should include 10 }
    its('numberOfAssessments') { should include 2 }
    its('projectStatuses') { should include 'Active' }
    its('provisioningStates') { should include 'Succeeded' }
  end
end
