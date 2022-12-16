resource_group = input(:resource_group, value: "")
wan_name = input(:inspec_virtual_wan, value: "")
location = input(:location, value: "")&.downcase&.gsub(" ", "")

control "verifies settings of an individual azure virtual WAN" do

  title "Testing the singular resource of azure_streaming_analytics_function."
  desc "Testing the singular resource of azure_streaming_analytics_function."

  describe azure_virtual_wan(resource_group: resource_group, name: wan_name) do
    it { should exist }
    its("name") { should include wan_name }
    its("type") { should eq "Microsoft.Network/virtualWans" }
    its("location") { should eq location }
    its("properties.type") { should eq "Standard" }
    its("properties.provisioningState") { should eq "Succeeded" }
  end
end
