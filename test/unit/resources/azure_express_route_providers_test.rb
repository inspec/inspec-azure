require_relative 'helper'
require 'azure_express_route_providers'

class AzureExpressRouteServiceProvidersConstructorTest < Minitest::Test
  def test_resource_type_not_ok
    assert_raises(ArgumentError) { AzureVirtualMachines.new(resource_provider: 'some_type') }
  end

  def tag_value_not_ok
    assert_raises(ArgumentError) { AzureVirtualMachines.new(tag_value: 'some_tag_value') }
  end

  def tag_name_not_ok
    assert_raises(ArgumentError) { AzureVirtualMachines.new(tag_name: 'some_tag_name') }
  end

  def test_resource_id_not_ok
    assert_raises(ArgumentError) { AzureVirtualMachines.new(resource_id: 'some_id') }
  end

  def test_name_not_ok
    assert_raises(ArgumentError) { AzureVirtualMachines.new(name: 'some_name') }
  end
end
<<<<<<< HEAD
=======

>>>>>>> 90a24640c1fcbbec3f1de26c07774f4b8946c398
