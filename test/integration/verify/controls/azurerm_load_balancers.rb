resource_group = attribute('resource_group', default: nil)
loadbalancer_name = attribute('lb_name', default: nil)

control 'azurerm_load_balancers' do

  describe azurerm_load_balancers(resource_group: resource_group) do
    it           { should exist }
    its('names') { should include loadbalancer_name }
  end

  describe azurerm_load_balancers do
    it            { should exist }
    its('names')  { should include loadbalancer_name }
  end
end
