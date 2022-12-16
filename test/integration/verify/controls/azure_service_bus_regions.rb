sku_name = "Standard"
control "test the properties of all Azure Service Bus Topics" do
  describe azure_service_bus_regions(sku: sku_name) do
    it { should exist }
    its("names") { should include "Central US" }
    its("codes") { should include "Central US" }
    its("fullNames") { should include "Central US" }
  end
end
