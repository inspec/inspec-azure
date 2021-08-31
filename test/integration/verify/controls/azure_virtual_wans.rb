wan_name = input(:inspec_virtual_wan, value: '')
location = input(:location, value: '')&.downcase&.gsub(' ', '')

control 'verifies settings of azure virtual WANs' do
  describe azure_virtual_wans do
    it { should exist }
    its('names') { should include wan_name }
    its('types') { should include 'Microsoft.Network/virtualWans' }
    its('locations') { should include location }
  end
end
