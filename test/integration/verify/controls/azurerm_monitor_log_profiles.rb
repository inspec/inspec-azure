control 'azurerm_monitor_log_profiles' do
  describe azurerm_monitor_log_profiles do
    its('names') { should include('default') }
  end
end
