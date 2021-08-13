dns_zones = input('dns_zones', value: nil)
dns_location = input('dns_location', value: nil)

control 'azure_dns_zones_resources' do
  describe azure_dns_zones_resources do
    it { should exist }
    its('names') { should include dns_zones }
    its('locations') { should include dns_location }
    its('types') { should include 'Microsoft.Network/dnszones' }
  end
end
