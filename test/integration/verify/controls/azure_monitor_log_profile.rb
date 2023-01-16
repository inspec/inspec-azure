log_profile = input("log_profile_name", value: nil)

control "azure_monitor_log_profile" do

  title "Testing the singular resource of azure_monitor_log_profile."
  desc "Testing the singular resource of azure_monitor_log_profile."

  describe azure_monitor_log_profile(name: log_profile) do
    it { should exist }
    its("retention_enabled") { should be true }
    its("retention_days")    { should eq(365) }
  end
end
