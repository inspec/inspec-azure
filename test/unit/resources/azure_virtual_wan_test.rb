require_relative "helper"
require "azure_virtual_wan"

class AzureVirtualWanConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureVirtualWan.new }
  end

  def test_resource_group_alone_not_ok
    assert_raises(ArgumentError) { AzureVirtualWan.new(resource_group: "some_type") }
  end
end
