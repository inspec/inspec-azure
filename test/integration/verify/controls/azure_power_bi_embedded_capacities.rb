power_bi_embedded_name = input(:power_bi_embedded_name, value: "")
location = input(:location, value: "")

control "Verify settings for all Azure Power BI Embedded Capacities" do
  describe azure_power_bi_embedded_capacities do
    it { should exist }
    its("names") { should include power_bi_embedded_name }
    its("locations") { should include location }
    its("modes") { should include "Gen2" }
    its("sku_names") { should include "A1" }
    its("sku_capacities") { should include 1 }
  end
end
