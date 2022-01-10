control 'azure_monitor_activity_log_alerts' do
  describe azure_monitor_activity_log_alerts do
    its('names') { should include('defaultLogAlert_5_3') }
  end
end
