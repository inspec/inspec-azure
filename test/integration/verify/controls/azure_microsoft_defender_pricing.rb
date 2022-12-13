control 'azure_microsoft_defender_pricing' do
  title 'Testing the singular resource of azure_microsoft_defender_pricing.'
  desc 'Testing the singular resource of azure_microsoft_defender_pricing.'

  describe azure_microsoft_defender_pricing(name: 'VirtualMachines') do
    it { should exist }
  end

  describe azure_microsoft_defender_pricing(name: 'VirtualMachines') do
    its('id') { should_not be_empty }
    its('name') { should eq 'VirtualMachines' }
    its('type') { should eq 'Microsoft.Security/pricings' }

    its('properties.subPlan') { should eq 'P2' }
    its('properties.pricingTier') { should eq 'Standard' }
    its('properties.freeTrialRemainingTime') { should eq 'PT0S' }
  end
end

control 'Test the Pricing Tier of each resources from the plural resource' do
  title 'Checking the pricing tier.'
  desc 'Test the Pricing Tier of each resources from the plural resource.'

  azure_microsoft_defender_pricings.entries.each do |entry|
    describe azure_microsoft_defender_pricing(name: entry.name) do
      its('properties.pricingTier') { should eq 'Standard' }
    end
  end
end
