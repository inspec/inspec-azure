log_profile = input('log_profile_name', value: nil)

control 'azure_monitor_log_profiles' do
  describe azure_monitor_log_profiles do
    its('names') { should include(log_profile) }
  end
end

control 'azure_monitor_log_profiles' do
  azure_monitor_log_profiles.ids.each do |id|
    describe azure_monitor_log_profile(resource_id: id) do
      it { should exist }
    end
  end
end
