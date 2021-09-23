location = input(:location, value: '')
resource_group = input(:resource_group, value: '')
project_name = input(:inspec_migrate_project_name, value: '')

control 'Verifies the settings of a Azure Migrate Assessment Project' do
  describe azure_migrate_assessment_project(resource_group: resource_group, name: project_name) do
    it { should exist }
    its('location') { should eq location }
    its('publicNetworkAccess') { should eq 'Enabled' }
    its('numberOfGroups') { should eq '1' }
    its('numberOfMachines') { should eq 10 }
    its('numberOfImportMachines') { should eq 10 }
    its('numberOfAssessments') { should eq 2 }
    its('projectStatus') { should eq 'Active' }
    its('provisioningState') { should eq 'Succeeded' }
  end
end
