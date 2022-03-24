resource_group = input('resource_group', value: nil)
webapp_name = input('webapp_name', value: nil)

control 'azurerm_webapps' do

  impact 1.0
  title 'Testing the plural resource of azurerm_webapps.'
  desc 'Testing the plural resource of azurerm_webapps.'

  describe azurerm_webapps(resource_group: resource_group) do
    it { should exist }
    its('names') { should include webapp_name }
  end
end
