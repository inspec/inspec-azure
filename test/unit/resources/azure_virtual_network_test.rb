require_relative 'helper'

class AzureVirtualNetworkConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureVirtualNetwork.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureVirtualNetwork.new(resource_provider: 'some_type') }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureVirtualNetwork.new(name: 'my-name') }
  end
end
