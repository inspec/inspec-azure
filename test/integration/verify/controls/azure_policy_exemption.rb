exemption_name = input(:policy_exemption_name, value: '')
resource_group = input(:resource_group, value: '')

control 'verify an exemption' do

  title 'Testing the singular resource of azure_policy_exemption.'
  desc 'Testing the singular resource of azure_policy_exemption.'

  describe azure_policy_exemption(exemption_name: exemption_name) do
    it { should exist }
    its('properties.exemptionCategory') { should eq 'Waiver' }
  end
end

control 'verify an exemption within a resource group' do

  title 'Testing the singular resource of azure_data_factory.'
  desc 'Testing the singular resource of azure_data_factory.'

  describe azure_policy_exemption(resource_group: resource_group, exemption_name: exemption_name) do
    it { should exist }
    its('properties.exemptionCategory') { should eq 'Waiver' }
  end
end
