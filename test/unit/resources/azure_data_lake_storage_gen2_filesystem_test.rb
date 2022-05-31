require_relative 'helper'
require 'azure_data_lake_storage_gen2_filesystem'

class AzureDataLakeStorageGen2FilesystemConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureDataLakeStorageGen2Filesystem.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureDataLakeStorageGen2Filesystem.new(resource_provider: 'some_type') }
  end

  def test_resource_group_name_alone_ok
    assert_raises(ArgumentError) { AzureDataLakeStorageGen2Filesystem.new(name: 'my-name', resource_group: 'test') }
  end
end
