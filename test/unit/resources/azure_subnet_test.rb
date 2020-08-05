require_relative 'helper'
require 'azure_subnet'

class AzureSubnetConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureSubnet.new }
  end

  # resource_type should not be allowed.
  def test_resource_type_not_ok
    assert_raises(ArgumentError) { AzureSubnet.new(resource_provider: 'some_type') }
  end

  # resource_group, vnet and name should be provided together
  def test_missing_required_params_1
    assert_raises(ArgumentError) { AzureSubnet.new(resource_group: 'some_r_g') }
  end

  def test_missing_required_params_2
    assert_raises(ArgumentError) { AzureSubnet.new(resource_group: 'some_r_g', vnet: 'virtual_net_name') }
  end
end
