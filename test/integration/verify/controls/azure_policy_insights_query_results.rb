# # policy_definition = input(:policy_definition_id, value: nil)
#
control 'azure_policy_insights_query_results for non-compliant resources' do
  text = 'IsCompliant eq false'
  describe azure_policy_insights_query_results(filter_free_text: text) do
    it { should exist }
    its('count') { should eq 1000 }
  end
end

control 'azure_policy_insights_query_results for virtualMachines' do
  text = "IsCompliant eq false and resourceId eq resourceType eq 'Microsoft.Compute/virtualMachines'"
  describe azure_policy_insights_query_results(filter_free_text: text) do
    it { should exist }
    its('is_compliant') { should cmp false }
  end
end
