require_relative 'helper'
require 'azure_data_lake_analytics_resource'

class AzureDataLakeAnalyticsResourcesConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureDataLakeAnalyticsResource.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureDataLakeAnalyticsResource.new(resource_provider: 'some_type') }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureDataLakeAnalyticsResource.new(name: 'my-name') }
  end
end
