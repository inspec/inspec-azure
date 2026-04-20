require_relative 'helper'
require 'azure_network_private_endpoints'

class AzureNetworkPrivateEndpointsConstructorTest < Minitest::Test
  # resource_type should not be allowed.
  def test_resource_type_not_ok
    assert_raises(ArgumentError) { AzureNetworkPrivateEndpoints.new(resource_provider: 'some_type') }
  end

  def test_tag_value_not_ok
    assert_raises(ArgumentError) { AzureNetworkPrivateEndpoints.new(tag_value: 'some_tag_value') }
  end

  def test_tag_name_not_ok
    assert_raises(ArgumentError) { AzureNetworkPrivateEndpoints.new(tag_name: 'some_tag_name') }
  end

  def test_resource_id_not_ok
    assert_raises(ArgumentError) { AzureNetworkPrivateEndpoints.new(resource_id: 'some_id') }
  end

  def test_name_not_ok
    assert_raises(ArgumentError) { AzureNetworkPrivateEndpoints.new(name: 'some_name') }
  end
end
