require_relative "helper"
require "azure_monitor_log_profile"

class AzureMonitorLogProfileConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureMonitorLogProfile.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureMonitorLogProfile.new(resource_provider: "some_type") }
  end
end
