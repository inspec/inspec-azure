resource_group = attribute('resource_group', default: nil)

control 'azurerm_sql_servers' do
  only_if { ENV['SQL'] }

  describe azurerm_sql_servers(resource_group) do
    it { should exist }
  end
end
