resource_group = input(:resource_group, value: '')
wan_name = input(:inspec_virtual_wan, value: '')
location = input(:location, value: '')&.downcase&.gsub(' ', '')

control 'Verifies settings of an individual azure virtual WAN' do

  impact 1.0
  title 'Testing the singular resource of azure_streaming_analytics_function.'
  desc 'Testing the singular resource of azure_streaming_analytics_function.'

  describe azure_virtual_wan(resource_group: resource_group, name: wan_name) do
    it { should exist }
    its('name') { should include wan_name }
    its('type') { should eq 'Microsoft.Network/virtualWans' }
    its('location') { should eq location }
    its('properties.type') { should eq 'Standard' }
    its('properties.provisioningState') { should eq 'Succeeded' }
  end
end

control 'azure_virtual_wan' do
  impact 1.0
  title 'Testing the singular resource of azure_virtual_wan.'
  desc 'Testing the singular resource of azure_virtual_wan.'

  describe azure_virtual_wan(resource_group: 'rgsoumyo', name: 'test') do
    it { should exist }
  end

  describe azure_virtual_wan(resource_group: 'rgsoumyo', name: 'test') do
    its('id') { should eq '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourceGroups/rgsoumyo/providers/Microsoft.Network/virtualWans/test' }
    its('name') { should eq 'test' }
    its('etag') { should eq 'W/\"54f51244-8da7-4b2e-9a20-23271cb9662c\"' }
    its('type') { should eq 'Microsoft.Network/virtualWans' }
    its('location') { should eq 'westus2' }

    its('properties.provisioningState') { should eq 'Succeeded' }
    its('properties.disableVpnEncryption') { should eq false }
    its('properties.allowBranchToBranchTraffic') { should eq true }
    its('properties.office365LocalBreakoutCategory') { should eq 'None' }
    its('properties.type') { should eq 'Standard' }
  end
end
