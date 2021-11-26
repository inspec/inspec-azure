require_relative 'helper'
require 'azure_service_bus_subscriptions'

class AzureServiceBusSubscriptionsConstructorTest < Minitest::Test
  # resource_type should not be allowed.
  def test_resource_type_not_ok
    assert_raises(ArgumentError) { AzureServiceBusSubscriptions.new(resource_provider: 'some_type') }
  end

  def tag_value_not_ok
    assert_raises(ArgumentError) { AzureServiceBusSubscriptions.new(tag_value: 'some_tag_value') }
  end

  def tag_name_not_ok
    assert_raises(ArgumentError) { AzureServiceBusSubscriptions.new(tag_name: 'some_tag_name') }
  end

  def test_name_not_ok
    assert_raises(ArgumentError) { AzureServiceBusSubscriptions.new(name: 'some_name') }
  end
end
