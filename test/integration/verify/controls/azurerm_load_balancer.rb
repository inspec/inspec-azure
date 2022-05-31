resource_group = attribute('resource_group', value: nil)
loadbalancer_name = attribute('lb_name', value: nil)

control 'azurerm_load_balancer' do

  impact 1.0
  title 'Testing the singular resource of azurerm_load_balancer.'
  desc 'Testing the singular resource of azurerm_load_balancer.'

  describe azurerm_load_balancer(resource_group: resource_group, loadbalancer_name: loadbalancer_name) do
    it                { should exist }
    its('id')         { should_not be_nil }
    its('name')       { should eq loadbalancer_name }
    its('sku')        { should_not be_nil }
    its('location')   { should_not be_nil }
    its('type')       { should eq 'Microsoft.Network/loadBalancers' }
  end
end
