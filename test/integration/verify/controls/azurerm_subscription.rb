control 'azurerm_subscription' do

  describe azurerm_subscription do
    its('name')       { should_not be_nil }
    its('locations')  { should include 'eastus' }
  end
end
