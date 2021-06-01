require_relative 'helper'
require 'azure_policy_insights_query_results'

class AzurePolicyInsightsQueryResultsConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzurePolicyInsightsQueryResults.new }
  end
end
