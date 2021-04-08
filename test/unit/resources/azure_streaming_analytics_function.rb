require_relative 'helper'
require 'azure_streaming_analytics_function'

class AzureStreamingFunctionConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureStreamingAnalyticsFunctions.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureStreamingAnalyticsFunctions.new(resource_provider: 'some_type') }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureStreamingAnalyticsFunctions.new(name: 'my-name') }
  end
end
