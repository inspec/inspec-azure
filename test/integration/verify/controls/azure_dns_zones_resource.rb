resource_group = input("resource_group", value: nil)
dns_zones = input("dns_zones", value: nil)
dns_location = input("dns_location", value: nil)

control "azure_dns_zones_resource" do

  title "Testing the singular resource of azure_dns_zones_resource."
  desc "Testing the singular resource of azure_dns_zones_resource."

  describe azure_dns_zones_resource(resource_group: resource_group, name: dns_zones) do
    it { should exist }
    its("name") { should eq dns_zones }
    its("type") { should eq "Microsoft.Network/dnszones" }
    its("location") { should include dns_location }
  end

  describe azure_dns_zones_resource(resource_group: resource_group, name: "fake") do
    it { should_not exist }
  end

  describe azure_dns_zones_resource(resource_group: "fake", name: dns_zones) do
    it { should_not exist }
  end
end
