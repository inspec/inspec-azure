resource_group = attribute('resource_group', default: nil)
api_management_name = attribute('api_management_name', default: '')

control 'azurerm_api_managements' do
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
