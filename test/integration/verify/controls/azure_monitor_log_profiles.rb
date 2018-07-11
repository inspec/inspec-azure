control 'azure_monitor_activity_log_prolfiles' do
  describe azure_monitor_log_profiles do
    its('names') { should include('default') }
  end
end
