require_relative 'helper'
require 'azure_subnets'

class AzureSubnetsConstructorTest < Minitest::Test
  # resource_provider should not be allowed.
  def test_resource_type_not_ok
    assert_raises(ArgumentError) { AzureSubnets.new(resource_provider: 'some_type') }
  end

  def tag_value_not_ok
    assert_raises(ArgumentError) { AzureSubnets.new(tag_value: 'some_tag_value') }
  end

  def tag_name_not_ok
    assert_raises(ArgumentError) { AzureSubnets.new(tag_name: 'some_tag_name') }
  end

  def test_resource_id_not_ok
    assert_raises(ArgumentError) { AzureSubnets.new(resource_id: 'some_id') }
  end

  def test_name_not_ok
    assert_raises(ArgumentError) { AzureSubnets.new(name: 'some_name') }
  end
end
