resource_group = attribute('resource_group', default: nil)
loadbalancer_name = attribute('lb_name', default: nil)

control 'azure_load_balancers' do

  describe azure_load_balancers(resource_group: resource_group) do
    it           { should exist }
    its('names') { should include loadbalancer_name }
  end

  describe azure_load_balancers do
    it            { should exist }
    its('names')  { should include loadbalancer_name }
  end
end
