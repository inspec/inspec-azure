control 'azure_subscription' do
  impact 1.0
  title 'Testing the singular resource of azure_subscription.'
  desc 'Testing the singular resource of azure_subscription.'
  
  describe azure_subscription do
    it { should exist }
  end
  
  describe azure_subscription do
    its('id') { should eq '80b824de-ec53-4116-9868-3deeab10b0cd' }
  end
end
