require_relative 'helper'
require 'azure_iothub_event_hub_consumer_group'

class AzureIotHubEventHubConsumerGroupConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureIotHubEventHubConsumerGroup.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureIotHubEventHubConsumerGroup.new(resource_provider: 'some_type') }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureIotHubEventHubConsumerGroup.new(name: 'my-name') }
  end
end
