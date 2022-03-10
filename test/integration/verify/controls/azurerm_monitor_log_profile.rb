log_profile = input('log_profile_name', value: nil)

control 'azurerm_monitor_log_profile' do

  impact 1.0
  title 'Testing the singular resource of azurerm_monitor_log_profile.'
  desc 'Testing the singular resource of azurerm_monitor_log_profile.'

  describe azurerm_monitor_log_profile(name: log_profile) do
    it { should exist }
    its('retention_enabled') { should be true }
    its('retention_days')    { should eq(365) }
  end
end
