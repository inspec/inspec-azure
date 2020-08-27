require_relative 'helper'
require 'azure_event_hub_namespace'

class AzureEventHubNamespaceConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureEventHubNamespace.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureEventHubNamespace.new(resource_provider: 'some_type') }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureEventHubNamespace.new(name: 'my-name') }
  end
end
