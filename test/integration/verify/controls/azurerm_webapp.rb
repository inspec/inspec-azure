resource_group = input('resource_group', value: nil)
webapp_name = input('webapp_name', value: nil)

control 'azurerm_webapp' do

  impact 1.0
  title 'Testing the singular resource of azurerm_webapp.'
  desc 'Testing the singular resource of azurerm_webapp.'

  describe azurerm_webapp(resource_group: resource_group, name: webapp_name) do
    it                { should have_identity }
    it                { should be_using_latest('aspnet') }
    its('properties') { should have_attributes(httpsOnly: true) }
  end
end
