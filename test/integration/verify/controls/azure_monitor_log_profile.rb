control 'azure_monitor_activity_log_profile' do
  describe azure_monitor_log_profile(name: 'default') do
    it { should exist }
    its('retention_enabled') { should be true }
    its('retention_days')    { should eq(365) }
  end
end
