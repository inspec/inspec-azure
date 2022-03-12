control 'azurerm_subscription' do

  impact 1.0
  title 'Testing the singular resource of azure_subscription.'
  desc 'Testing the singular resource of azure_subscription.'

  describe azurerm_subscription do
    its('name') { should_not be_nil }
    its('locations') { should include 'eastus' }
  end
end

control 'azure_subscription' do

  impact 1.0
  title 'Testing the singular resource of azure_subscription.'
  desc 'Testing the singular resource of azure_subscription.'

  subscription_id = azure_subscription.id
  physical_locations_size = azure_subscription.physical_locations.size
  logical_locations_size = azure_subscription.logical_locations.size

  describe azure_subscription(id: subscription_id) do
    it { should exist }
    its('all_locations.size') { should eq physical_locations_size + logical_locations_size }
  end
end
