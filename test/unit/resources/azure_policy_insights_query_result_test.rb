require_relative "helper"
require "azure_policy_insights_query_result"

class AzurePolicyInsightsQueryResultTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzurePolicyInsightsQueryResult.new }
  end

  # resource_provider should not be allowed.
  def test_only_policy_definition_not_ok
    assert_raises(ArgumentError) { AzurePolicyInsightsQueryResult.new(policy_definition: "new_policy") }
  end

  def test_only_resource_id
    resource_id = "/subscriptions/80b824de-ec53-4116-9868-3deeab10b0cd/resourcegroups/edm_app_management_storage/providers/microsoft.insights/actiongroups/application insights smart detection"
    assert_raises(ArgumentError) { AzurePolicyInsightsQueryResult.new(resource_id: resource_id) }
  end
end
