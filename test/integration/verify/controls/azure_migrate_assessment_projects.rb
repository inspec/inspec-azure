location = input(:location, value: '')

control 'Verifies settings for a collection of Azure Migrate Assessment Projects' do
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
