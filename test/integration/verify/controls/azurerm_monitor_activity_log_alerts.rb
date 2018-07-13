control 'azurerm_monitor_activity_log_alerts' do
  describe azurerm_monitor_activity_log_alerts do
    its('names') { should include('defaultLogAlert_5_3') }
  end
end
