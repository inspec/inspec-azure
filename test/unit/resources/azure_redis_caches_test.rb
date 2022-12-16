require_relative "helper"
require "azure_redis_caches"

class AzureRedisCachesConstructorTest < Minitest::Test
  def tag_value_not_ok
    assert_raises(ArgumentError) { AzureRedisCaches.new(tag_value: "some_tag_value") }
  end

  def test_resource_id_not_ok
    assert_raises(ArgumentError) { AzureRedisCaches.new(resource_id: "some_id") }
  end
end
