require_relative "helper"
require "azure_cdn_profile"

class AzureCDNProfileConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureCDNProfile.new }
  end

  def test_resource_group_alone_not_ok
    assert_raises(ArgumentError) { AzureCDNProfile.new(resource_provider: "some_type") }
  end
end
