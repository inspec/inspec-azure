policy_definition = input(:policy_definition_id, value: nil)

control 'azure_policy_insights_query_results for non-compliant resources' do
  text = 'IsCompliant eq false'
  describe azure_policy_insights_query_results(policy_definition: policy_definition, filter_free_text: text) do
    it { should_not exist }
    its('count') { should eq 0 }
  end
end

control 'azure_policy_insights_query_results for virtualMachines' do
  text = 'IsCompliant eq false and resourceType eq Microsoft.Compute/virtualMachines'
  describe azure_policy_insights_query_results(policy_definition: policy_definition, filter_free_text: text) do
    it { should exist }
    its('isCompliant') { should_not include false }
  end
end
