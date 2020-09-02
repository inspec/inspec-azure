require_relative 'helper'
require 'azure_storage_account_blob_container'

class AzureStorageAccountBlobContainerConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureStorageAccountBlobContainer.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureStorageAccountBlobContainer.new(resource_provider: 'some_type') }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureStorageAccountBlobContainer.new(name: 'my-name') }
  end
end
