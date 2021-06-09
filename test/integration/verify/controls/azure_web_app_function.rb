resource_group = input('resource_group', value: nil)
site_name      = input('web_app_function_app_name', value: nil)
function_name  = input('web_app_function_name', value: nil)

control 'azure_web_app_function' do
  describe azure_web_app_function(resource_group: resource_group, site_name: site_name, function_name: function_name) do
    it { should exist } # The test itself.
    its('name')                             { should cmp "#{site_name}/#{function_name}" }
    its('type')                             { should cmp 'Microsoft.Web/sites/functions' }
    its('properties.name')                  { should cmp function_name }
    its('properties.language')              { should cmp 'Javascript' }
  end
end
