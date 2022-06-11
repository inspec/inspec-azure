require_relative 'helper'
require 'azure_cdn_profiles'

class AzureCDNProfilesConstructorTest < Minitest::Test
  def tag_value_not_ok
    assert_raises(ArgumentError) { AzureCDNProfiles.new(tag_value: 'some_tag_value') }
  end

  def test_resource_id_alone_not_ok
    assert_raises(ArgumentError) { AzureCDNProfiles.new(resource_id: 'some_id') }
  end
end

