require_relative "helper"
require "azure_container_group"

class AzureContainerGroupConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureContainerGroup.new }
  end

  def test_resource_group_alone_not_ok
    assert_raises(ArgumentError) { AzureContainerGroup.new(resource_provider: "some_type") }
  end
end
