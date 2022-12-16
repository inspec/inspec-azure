require_relative "helper"
require "azure_resource_health_emerging_issues"

class AzureResourceHealthEmergingIssuesConstructorTest < Minitest::Test
  def test_resource_type_alone_not_ok
    assert_raises(ArgumentError) { AzureResourceHealthEmergingIssues.new(resource_provider: "some_type") }
  end

  def tag_value_not_ok
    assert_raises(ArgumentError) { AzureResourceHealthEmergingIssues.new(tag_value: "some_tag_value") }
  end

  def tag_name_not_ok
    assert_raises(ArgumentError) { AzureResourceHealthEmergingIssues.new(tag_name: "some_tag_name") }
  end

  def test_name_not_ok
    assert_raises(ArgumentError) { AzureResourceHealthEmergingIssues.new(name: "some_name") }
  end
end
