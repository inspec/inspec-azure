policy_definition = input(:policy_definition_id, value: nil)
resource_id = input(:policy_definition_associated_cosmodb_id,
                    value: '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourcegroups/edm_app_management_storage/providers/microsoft.insights/actiongroups/application insights smart detection')

# # A simple example to check if a specified resource has policy setup and is compliant
control 'azure_policy_insights_query_result for a specified resource' do
  title 'A simple example to check if a specified resource has policy setup and is compliant'
  describe azure_policy_insights_query_result(policy_definition: policy_definition, resource_id: resource_id) do
    it { should exist }
    it { should be_compliant }
  end
end

# An example to to check compliance results for every resource that has policy
azure_policy_insights_query_results(policy_definition: policy_definition).resourceIds.each do |id|
  control "Compliance for each Resource Level #{id}" do
    describe azure_policy_insights_query_result(policy_definition: policy_definition, resource_id: id) do
      it { should be_compliant }
    end
  end
end
