require_relative "helper"
require "azure_resource_health_events"

class AzureResourceHealthEventsConstructorTest < Minitest::Test
  def test_resource_type_alone_not_ok
    assert_raises(ArgumentError) { AzureResourceHealthEvents.new(resource_provider: "some_type") }
  end

  def tag_value_not_ok
    assert_raises(ArgumentError) { AzureResourceHealthEvents.new(tag_value: "some_tag_value") }
  end

  def tag_name_not_ok
    assert_raises(ArgumentError) { AzureResourceHealthEvents.new(tag_name: "some_tag_name") }
  end

  def test_name_not_ok
    assert_raises(ArgumentError) { AzureResourceHealthEvents.new(name: "some_name") }
  end
end
