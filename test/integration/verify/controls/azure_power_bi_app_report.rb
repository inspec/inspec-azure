app_id = input(:app_id, value: "")
report_id = input(:report_id, value: "")

control "Verify the settings of a Power BI App Report" do
  describe azure_power_bi_app_report(app_id: app_id, report_id: report_id) do
    it { should exist }
    its("name") { should eq "Finance" }
    its("webUrl") { should_not be_empty }
  end
end
