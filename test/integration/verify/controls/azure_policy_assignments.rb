control 'azure_policy_assignments' do
  title 'azure_policy_assignments tests'
  desc  'azure_policy_assignments tests'
  impact 0.7

  describe azure_policy_assignments do
    it { should exist }
    its('names.class') { should eq 'Array' }
    its('displayNames.class') { should eq 'Array' }
  end
end
