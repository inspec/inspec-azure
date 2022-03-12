control 'azure_policy_definitions' do

  impact 1.0
  title 'Testing the plural resource of azure_policy_definitions.'
  desc 'Testing the plural resource of azure_policy_definitions.'

  describe azure_policy_definitions(built_in_only: true) do
    it { should exist }
    its('policy_types') { should_not include 'Custom' }
  end
end
