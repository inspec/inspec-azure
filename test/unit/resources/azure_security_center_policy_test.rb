require_relative 'helper'
require 'azure_security_center_policy'

class AzureSecurityCenterPolicyConstructorTest < Minitest::Test
  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureSecurityCenterPolicy.new(resource_provider: 'some_type') }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureSecurityCenterPolicy.new(name: 'my-name') }
  end
end
