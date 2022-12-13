control 'azure_microsoft_defender_pricings' do
  title 'Testing the singular resource of azure_microsoft_defender_pricing.'
  desc 'Testing the singular resource of azure_microsoft_defender_pricing.'

  describe azure_microsoft_defender_pricings do
    it { should exist }
  end

  describe azure_microsoft_defender_pricings do
    its('ids') { should_not be_empty }
    its('names') { should include 'VirtualMachines' }
    its('types') { should include 'Microsoft.Security/pricings' }

    its('subPlans') { should include 'P2' }
    its('pricingTiers') { should include 'Standard' }
    its('freeTrialRemainingTimes') { should include 'PT0S' }
  end
end
