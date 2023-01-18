log_profile = input("log_profile_name", value: nil)

control "azure_monitor_log_profiles" do

  title "Testing the plural resource of azure_monitor_log_profiles."
  desc "Testing the plural resource of azure_monitor_log_profiles."

  describe azure_monitor_log_profiles do
    its("names") { should include(log_profile) }
  end

  azure_monitor_log_profiles.ids.each do |id|
    describe azure_monitor_log_profile(resource_id: id) do
      it { should exist }
    end
  end
end
