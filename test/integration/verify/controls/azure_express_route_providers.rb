express_route_name = input('express_route_name', value: nil)

control 'azure_express_route_providers' do
  describe azure_express_route_providers do
    its('names') { should include express_route_name }
    its('types') { should include 'Microsoft.Network/expressRouteServiceProviders' }
    its('provisioning_states') { should include('Succeeded') }
  end
end
