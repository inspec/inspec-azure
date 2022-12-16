require_relative "helper"
require "azure_container_groups"

class AzureContainerGroupsConstructorTest < Minitest::Test
  def tag_value_not_ok
    assert_raises(ArgumentError) { AzureContainerGroups.new(tag_value: "some_tag_value") }
  end

  def test_resource_id_alone_not_ok
    assert_raises(ArgumentError) { AzureContainerGroups.new(resource_id: "some_id") }
  end
end
