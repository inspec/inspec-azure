policy_definition = input(:policy_definition_id, value: nil)
resource_id = input(:policy_definition_associated_cosmodb_id,
                    value: '/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourcegroups/315-releng-e2e-test/providers/microsoft.compute/virtualmachines/chefserver-ubuntu-1804')

control 'azure_policy_insights_query_result for a specified resource' do
  title 'A simple example to check if a specified resource has policy setup and is compliant'
  describe azure_policy_insights_query_result(policy_definition: policy_definition, resource_id: resource_id) do
    it { should exist }
    it { should be_compliant }
  end
end
