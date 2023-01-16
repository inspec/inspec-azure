require_relative "helper"
require "azure_subscription"

class AzureSubscriptionConstructorTest < Minitest::Test
  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureSubscription.new(resource_provider: "some_type") }
  end

  def test_name_not_ok
    assert_raises(ArgumentError) { AzureSubscription.new(name: "some_name") }
  end
end
