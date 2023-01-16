resource_group = input("resource_group", value: nil)
iothub_resource_name = input("iothub_resource_name", value: nil)

control "azure_iothub" do
  title "Testing the singular resource of azure_iothub."
  desc "Testing the singular resource of azure_iothub."

  describe azure_iothub(resource_group: resource_group, resource_name: iothub_resource_name) do
    it          { should exist }
    its("name") { should eq iothub_resource_name }
    its("type") { should eq "Microsoft.Devices/IotHubs" }
  end

  describe azure_iothub(resource_group: resource_group, resource_name: "fake") do
    it { should_not exist }
  end
end
