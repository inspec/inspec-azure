resource_group = attribute('resource_group', value: nil)
api_management_name = attribute('api_management_name', value: '')

control 'azurerm_api_managements' do

  title 'Testing the plural resource of azurerm_api_managements.'
  desc 'Testing the plural resource of azurerm_api_managements.'

  only_if { !api_management_name.empty? }
  describe azurerm_api_managements(resource_group: resource_group) do
    it           { should exist }
    its('names') { should include api_management_name }
  end

  describe azurerm_api_managements do
    it            { should exist }
    its('names')  { should include api_management_name }
  end
end
