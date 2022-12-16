require_relative "helper"
require "azure_subscriptions"

class AzureSubscriptionsConstructorTest < Minitest::Test
  # Parameter not allowed.
  def test_parameter_not_ok
    assert_raises(ArgumentError) { AzureSubscriptions.new(any: "some_value") }
  end
end
