require_relative 'helper'
require 'azure_sentinel_incidents_resource'

class AzureSentinelIncidentsResourceTestConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureSentinelIncidentsResource.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureSentinelIncidentsResource.new(resource_provider: 'some_type') }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureSentinelIncidentsResource.new(name: 'my-name') }
  end
end
