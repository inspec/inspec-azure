control 'azure_microsoft_defender_setting' do
  title 'Testing the singular resource of azure_microsoft_defender_setting.'
  desc 'Testing the singular resource of azure_microsoft_defender_setting.'

  describe azure_microsoft_defender_setting(name: 'MCAS') do
    it { should exist }
  end

  describe azure_microsoft_defender_setting(name: 'MCAS') do
    its('id') { should_not be_empty }
    its('name') { should eq 'MCAS' }
    its('type') { should eq 'Microsoft.Security/settings' }
    its('kind') { should eq 'DataExportSettings' }
  end

  describe azure_microsoft_defender_setting(name: 'MCAS') do
    its('properties.enabled') { should be true }
  end
end
