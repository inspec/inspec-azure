require_relative "helper"
require "azure_redis_cache"

class AzureRedisCacheConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureRedisCache.new }
  end

  def test_resource_provider_alone_not_ok
    assert_raises(ArgumentError) { AzureRedisCache.new(resource_provider: "some_type") }
  end
end
