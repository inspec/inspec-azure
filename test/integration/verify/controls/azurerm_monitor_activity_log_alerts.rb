control 'azurerm_monitor_activity_log_alerts' do

  impact 1.0
  title 'Testing the plural resource of azurerm_monitor_activity_log_alerts.'
  desc 'Testing the plural resource of azurerm_monitor_activity_log_alerts.'

  describe azurerm_monitor_activity_log_alerts do
    its('names') { should include('defaultLogAlert_5_3') }
  end
end
