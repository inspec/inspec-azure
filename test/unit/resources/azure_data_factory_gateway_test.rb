require_relative 'helper'
require 'azure_data_factory_gateway'

class AzureDataFactoryGatewayTestConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureDataFactoryGateway.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureDataFactoryGateway.new(resource_provider: 'some_type') }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureDataFactoryGateway.new(name: 'my-name') }
  end
end
