require_relative "helper"
require "azure_resource_health_emerging_issue"

class AzureResourceHealthEmergingIssueConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureResourceHealthEmergingIssue.new }
  end

  def test_resource_group_alone_not_ok
    assert_raises(ArgumentError) { AzureResourceHealthEmergingIssue.new(resource_group: "some_type") }
  end
end
