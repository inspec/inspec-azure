app_id = input(:app_id, value: "")

control "Verify the settings of all Power BI Apps" do

  title "Testing the plural resource of azure_power_bi_apps."
  desc "Testing the plural resource of azure_power_bi_apps."

  describe azure_power_bi_apps do
    it { should exist }
    its("ids") { should include app_id }
  end
end
