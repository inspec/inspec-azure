wan_name = input(:inspec_virtual_wan, value: '')
location = input(:location, value: '')&.downcase&.gsub(' ', '')

control 'Verifies settings of azure virtual WANs' do
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


control 'azure_virtual_wans' do
  impact 1.0
  title 'Testing the plural resource of azure_virtual_wans.'
  desc 'Testing the plural resource of azure_virtual_wans.'
  
  describe azure_virtual_wans do
    it { should exist }
  end
  
  describe azure_virtual_wans do
    its('ids') { should include '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/rgsoumyo/providers/Microsoft.Network/virtualWans/test' }
    its('names') { should include 'test' }
    its('etags') { should include 'W/\"54f51244-8da7-4b2e-9a20-23271cb9662c\"' }
    its('types') { should include 'Microsoft.Network/virtualWans' }
    its('locations') { should include 'westus2' }
  end
end
