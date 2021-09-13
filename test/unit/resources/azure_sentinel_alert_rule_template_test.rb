require_relative 'helper'
require 'azure_alert_rule_template'

class AzureAlertRuleTemplateConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureSentinelAlertRuleTemplate.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureSentinelAlertRuleTemplate.new(resource_provider: 'some_type') }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureSentinelAlertRuleTemplate.new(name: 'my-name') }
  end
end
