require_relative "helper"
require "azure_sentinel_alert_rule"

class AzureAlertRuleConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureSentinelAlertRule.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureSentinelAlertRule.new(resource_provider: "some_type") }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureSentinelAlertRule.new(name: "my-name") }
  end
end
