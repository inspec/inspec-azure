require_relative "helper"
require "azure_resource_health_availability_status"

class AzureResourceHealthAvailabilityStatusConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureResourceHealthAvailabilityStatus.new }
  end

  def test_resource_group_alone_not_ok
    assert_raises(ArgumentError) { AzureResourceHealthAvailabilityStatus.new(resource_group: "large_vms") }
  end
end
