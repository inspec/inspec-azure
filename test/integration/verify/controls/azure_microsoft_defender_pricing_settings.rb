control 'azure_microsoft_defender_settings' do
  impact 1.0
  title 'Testing the plural resource of azure_microsoft_defender_settings.'
  desc 'Testing the plural resource of azure_microsoft_defender_settings.'
  
  describe azure_microsoft_defender_settings do
    it { should exist }
  end
  
  describe azure_microsoft_defender_settings do
    its('ids') { should_not be_empty }
    its('names') { should include 'MCAS' }
    its('types') { should include 'Microsoft.Security/settings' }
    its('kinds') { should include 'DataExportSettings' }
    its('properties') { should_not be_empty }
  end
end
