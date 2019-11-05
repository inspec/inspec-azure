resource_group = input('resource_group', value: nil)
webapp_name = input('webapp_name', value: nil)

control 'azurerm_webapps' do
  describe azurerm_webapps(resource_group: resource_group) do
    it { should exist }
    its('names') { should include webapp_name }
  end
end
