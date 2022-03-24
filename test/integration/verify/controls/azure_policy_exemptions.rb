exemption_name = input(:policy_exemption_name, value: '')

control 'check if azure policy exemptions has waiver category' do

  impact 1.0
  title 'Testing the plural resource of azure_policy_exemption.'
  desc 'Testing the plural resource of azure_policy_exemption.'

  describe azure_policy_exemptions do
    it { should exist }
    its('created_by_types') { should include 'User' }
    its('exemption_categories') { should include 'Waiver' }
    its('types') { should include 'Microsoft.Authorization/policyExemptions' }
  end
end

control 'check exemptions using nested filtering' do

  impact 1.0
  title 'Testing the plural resource of azure_policy_exemption.'
  desc 'Testing the plural resource of azure_policy_exemption.'

  azure_policy_exemptions.where(name: exemption_name, type: 'Microsoft.Authorization/policyExemptions').names.each do |name|
    control "check exemptions using nested filtering for exemption: #{name}" do
      describe azure_policy_exemption(exemption_name: name) do
        it { should exist }
        its('properties.exemptionCategory') { should eq 'Waiver' }
      end
    end
  end

  describe azure_policy_exemptions do
    it { should exist }
  end
end
