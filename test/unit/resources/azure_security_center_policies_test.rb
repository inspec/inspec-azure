require_relative "helper"
require "azure_security_center_policies"

class AzureSecurityCenterPoliciesConstructorTest < Minitest::Test
  # Parameter not allowed.
  def test_parameter_not_ok
    assert_raises(ArgumentError) { AzureSecurityCenterPolicies.new(any: "some_value") }
  end
end
