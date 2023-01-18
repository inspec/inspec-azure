resource_group = input("resource_group", value: nil)
loadbalancer_name = input("lb_name", value: nil)

control "azure_load_balancer" do
  title "Testing the singular resource of azure_load_balancer."
  desc "Testing the singular resource of azure_load_balancer."

  describe azure_load_balancer(resource_group: resource_group, loadbalancer_name: loadbalancer_name) do
    it                { should exist }
    its("id")         { should_not be_nil }
    its("name")       { should eq loadbalancer_name }
    its("sku")        { should_not be_nil }
    its("location")   { should_not be_nil }
    its("type")       { should eq "Microsoft.Network/loadBalancers" }
  end
end
