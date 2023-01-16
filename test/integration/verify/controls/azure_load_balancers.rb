resource_group = input("resource_group", value: nil)
loadbalancer_name = input("lb_name", value: nil)

control "azure_load_balancers" do
  title "Testing the plural resource of azure_load_balancers."
  desc "Testing the plural resource of azure_load_balancers."

  describe azure_load_balancers(resource_group: resource_group) do
    it           { should exist }
    its("names") { should include loadbalancer_name }
  end

  describe azure_load_balancers do
    it            { should exist }
    its("names")  { should include loadbalancer_name }
  end
end
