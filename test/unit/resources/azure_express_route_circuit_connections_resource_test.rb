require_relative 'helper'
 require 'azure_express_route_circuit'

 class AzureExpressRouteCircuitConstructorTest < Minitest::Test
   def test_empty_param_not_ok
     assert_raises(ArgumentError) { AzureExpressRouteCircuit.new }
   end

   # resource_provider should not be allowed.
   def test_resource_provider_not_ok
     assert_raises(ArgumentError) { AzureExpressRouteCircuit.new(resource_provider: 'some_type') }
   end

   def test_resource_group
     assert_raises(ArgumentError) { AzureExpressRouteCircuit.new(name: 'my-name') }
   end
 end