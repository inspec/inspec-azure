require_relative "helper"
require "azure_policy_exemption"

class AzurePolicyExemptionConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzurePolicyExemption.new }
  end

  def test_resource_group_alone_not_ok
    assert_raises(ArgumentError) { AzurePolicyExemption.new(resource_provider: "some_type") }
  end
end
