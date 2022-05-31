require_relative 'helper'
require 'azure_service_bus_namespace'

class AzureServiceBusNamespaceConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureServiceBusNamespace.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureServiceBusNamespace.new(resource_provider: 'some_type') }
  end

  def test_resource_group_name_alone_not_ok
    assert_raises(ArgumentError) { AzureServiceBusNamespace.new(resource_group: 'test') }
  end
end
