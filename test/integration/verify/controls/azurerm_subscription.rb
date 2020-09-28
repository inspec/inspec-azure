control 'azurerm_subscription' do

  describe azurerm_subscription do
    its('name') { should_not be_nil }
    its('locations') { should include 'eastus' }
  end
end

control 'azure_subscription' do

  subscription_id = azure_subscription.id
  describe azure_subscription(id: subscription_id) do
    it { should exist }
  end
end
