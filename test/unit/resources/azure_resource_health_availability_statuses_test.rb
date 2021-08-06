require_relative 'helper'
require 'azure_resource_health_availability_statuses'

class AzureResourceHealthAvailabilityStatusesConstructorTest < Minitest::Test
  def tag_value_not_ok
    assert_raises(ArgumentError) { AzureResourceHealthAvailabilityStatuses.new(tag_value: 'some_tag_value') }
  end

  def test_resource_id_alone_not_ok
    assert_raises(ArgumentError) { AzureResourceHealthAvailabilityStatuses.new(resource_id: 'some_id') }
  end
end
