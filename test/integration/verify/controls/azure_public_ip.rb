resource_group = input("resource_group", value: nil)
address_name = input("ip_address_name", value: "")

control "azure_public_ip" do
  title "Testing the singular resource of azure_public_ip."
  desc "Testing the singular resource of azure_public_ip."

  only_if { !address_name.empty? }
  
  describe azure_public_ip(resource_group: resource_group, name: address_name) do
    it                                                       { should exist }
    its("name")                                              { should cmp address_name }
    its("type")                                              { should cmp "Microsoft.Network/publicIPAddresses" }
    its("properties.provisioningState")                      { should cmp "Succeeded" }
    its("properties.publicIPAddressVersion")                 { should eq "IPv4" }
  end

  describe azure_public_ip(resource_group: resource_group, name: "fake") do
    it { should_not exist }
  end

  describe azure_public_ip(resource_group: "does-not-exist", name: "fake") do
    it { should_not exist }
  end
end
