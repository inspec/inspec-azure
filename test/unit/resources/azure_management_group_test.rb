require_relative "helper"
require "azure_management_group"

class AzureManagementGroupConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureManagementGroup.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureManagementGroup.new(resource_provider: "some_type") }
  end
end
