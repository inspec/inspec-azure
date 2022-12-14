require_relative "helper"
require "azure_data_lake_storage_gen2_paths"

class AzureDataLakeStorageGen2PathsConstructorTest < Minitest::Test
  # resource_type should not be allowed.
  def test_resource_type_not_ok
    assert_raises(ArgumentError) { AzureDataLakeStorageGen2Paths.new(resource_provider: "some_type") }
  end

  def tag_value_not_ok
    assert_raises(ArgumentError) { AzureDataLakeStorageGen2Paths.new(tag_value: "some_tag_value") }
  end

  def tag_name_not_ok
    assert_raises(ArgumentError) { AzureDataLakeStorageGen2Paths.new(tag_name: "some_tag_name") }
  end

  def test_name_not_ok
    assert_raises(ArgumentError) { AzureDataLakeStorageGen2Paths.new(name: "some_name") }
  end
end
