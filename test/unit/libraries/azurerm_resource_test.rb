require "inspec/resource"

require_relative "../test_helper"
require_relative "../../../libraries/azurerm_resource"
require_relative "../../../libraries/azurerm_subscription"

class AzurermResourceTest < Minitest::Test
  def setup
    @resource = AzurermResource.new
    @resource.instance_variable_set("@__resource_name__", "azurerm_resource")
    @sub = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxx"
    @resource_group = "my-rg"
  end

  def test_valid_conversion
    id = "/subscriptions/#{@sub}/resourceGroups/#{@resource_group}/providers/Microsoft.Compute/disks/data-disk"

    result = @resource.send(:id_to_h, id)

    assert_equal(result.class.name,        Hash.name)
    assert_equal(result[:subscriptions],   @sub)
    assert_equal(result[:resource_groups], @resource_group)
    assert_equal(result[:providers],       "Microsoft.Compute")
    assert_equal(result[:disks],           "data-disk")
  end

  def test_id_not_set
    assert_raises ArgumentError do
      @resource.send(:id_to_h)
    end
  end

  def test_id_invalid
    assert_raises ArgumentError do
      @resource.send(:id_to_h, "not a valid ID")
    end
  end

  def test_id_malformed
    id = "/subscriptions/#{@sub}/resourceGroups/#{@resource_group}/providers/Microsoft.Compute/disksMissingLastSegment"

    assert_raises ArgumentError do
      @resource.send(:id_to_h, id)
    end
  end
end
