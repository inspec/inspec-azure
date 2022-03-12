wan_name = input(:inspec_virtual_wan, value: '')
location = input(:location, value: '')&.downcase&.gsub(' ', '')

control 'verifies settings of azure virtual WANs' do

  impact 1.0
  title 'Testing the plural resource of azure_virtual_wans.'
  desc 'Testing the plural resource of azure_virtual_wans.'

  describe azure_virtual_wans do
    it { should exist }
    its('names') { should include wan_name }
    its('types') { should include 'Microsoft.Network/virtualWans' }
    its('locations') { should include location }
  end
end
