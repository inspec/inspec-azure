control 'azure_policy_definitions' do
  describe azure_policy_definitions(built_in_only: true) do
    it { should exist }
    its('policy_types') { should_not include 'Custom' }
  end
end
