resource_group = attribute("resource_group", default: nil)
iothub_resource_name = attribute("iothub_resource_name", default: nil)

control "azurerm_iothub" do

  describe azurerm_iothub(resource_group: resource_group, resource_name: iothub_resource_name) do
    it          { should exist }
    its("name") { should eq iothub_resource_name }
    its("type") { should eq "Microsoft.Devices/IotHubs" }
  end

  describe azurerm_iothub(resource_group: resource_group, resource_name: "fake") do
    it { should_not exist }
  end
end
