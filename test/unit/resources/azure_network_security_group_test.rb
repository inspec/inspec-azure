require_relative 'helper'
require_relative '../../../libraries/azure_network_security_group'

class AzureNetworkSecurityGroupConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureNetworkSecurityGroup.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureNetworkSecurityGroup.new(resource_provider: 'some_type') }
  end

  def test_resource_group_should_exist
    assert_raises(ArgumentError) { AzureNetworkSecurityGroup.new(name: 'my-name') }
  end
end
