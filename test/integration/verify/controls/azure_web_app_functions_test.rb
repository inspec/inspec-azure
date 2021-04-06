resource_group  = input('resource_group',  value: nil)
site_name       = input('site_name', value: nil)
function_name   = input('function_name',   value: nil)

control 'azure_web_app_functions' do
  describe azure_web_app_functions(resource_group: resource_group, site_name: site_name) do
    it           { should exist }
    its('names') { should be_an(Array) }
    its('names') { should include("#{site_name}/#{function_name}") }
  end
end
