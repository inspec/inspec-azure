# # policy_definition = input(:policy_definition_id, value: nil)

control "azure_policy_insights_query_results for non-compliant resources" do
  text = "IsCompliant eq false"

  title "Testing the plural resource of azure_policy_insights_query_results."
  desc "Testing the plural resource of azure_policy_insights_query_results."

  describe azure_policy_insights_query_results(filter_free_text: text) do
    it { should exist }
    its("count") { should eq 1000 }
  end
end

control "azure_policy_insights_query_results for virtualMachines" do
  text = "IsCompliant eq false and resourceId eq resourceType eq 'Microsoft.Compute/virtualMachines'"

  title "Testing the plural resource of azure_policy_insights_query_results."
  desc "Testing the plural resource of azure_policy_insights_query_results."

  describe azure_policy_insights_query_results(filter_free_text: text) do
    it { should exist }
    its("is_compliant") { should cmp false }
  end
end
