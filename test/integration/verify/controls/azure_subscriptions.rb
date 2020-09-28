control 'azure_subscriptions' do

  subscription_name = azure_subscription.name
  describe azure_subscriptions do
    its('names') { should include(subscription_name) }
  end

  azure_subscriptions.ids.each do |id|
    describe azure_subscription(id: id) do
      it { should exist }
    end
  end
end
