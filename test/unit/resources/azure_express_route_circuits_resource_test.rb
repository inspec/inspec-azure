require_relative 'helper'
require 'azure_express_route_circuits_resource'

class AzureExpressRouteCircuitsResourceConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureExpressRouteCircuitsResource.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureExpressRouteCircuitsResource.new(resource_provider: 'some_type') }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureExpressRouteCircuitsResource.new(name: 'my-name') }
  end
end
