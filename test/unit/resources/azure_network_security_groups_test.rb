require_relative 'helper'
require 'azure_network_security_groups'

class AzureNetworkSecurityGroupsConstructorTest < Minitest::Test
  # resource_type should not be allowed.
  def test_resource_type_not_ok
    assert_raises(ArgumentError) { AzureNetworkSecurityGroups.new(resource_provider: 'some_type') }
  end

  def tag_value_not_ok
    assert_raises(ArgumentError) { AzureNetworkSecurityGroups.new(tag_value: 'some_tag_value') }
  end

  def tag_name_not_ok
    assert_raises(ArgumentError) { AzureNetworkSecurityGroups.new(tag_name: 'some_tag_name') }
  end

  def test_resource_id_not_ok
    assert_raises(ArgumentError) { AzureNetworkSecurityGroups.new(resource_id: 'some_id') }
  end

  def test_name_not_ok
    assert_raises(ArgumentError) { AzureNetworkSecurityGroups.new(name: 'some_name') }
  end
end
