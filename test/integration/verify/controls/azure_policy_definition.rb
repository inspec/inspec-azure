control 'azure_policy_definition' do

  title 'Testing the singular resource of azure_policy_definition.'
  desc 'Testing the singular resource of azure_policy_definition.'

  describe azure_policy_definition(name: '0062eb8b-dc75-4718-8ea5-9bb4a9606655', built_in: true) do
    it { should exist }
    its('properties.policyType') { should cmp 'Static' }
    its('properties.policyRule.then.effect') { should cmp 'audit' }
    it { should_not be_custom }
  end
end
