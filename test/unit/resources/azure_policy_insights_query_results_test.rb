require_relative 'helper'
require 'azure_policy_insights_query_results'

class AzurePolicyInsightsQueryResultsConstructorTest < Minitest::Test
  def test_empty_param_ok
    AzurePolicyInsightsQueryResults.new
  end
end
