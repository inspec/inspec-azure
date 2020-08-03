require_relative 'helper'
require 'azure_generic_resources'

class AzureGenericResourcesConstructorTest < Minitest::Test
  # resource_id is not allowed
  def test_resource_id_not_ok
    assert_raises(ArgumentError) { AzureGenericResources.new(resource_id: 'some_id') }
  end

  def test_api_version_not_ok
    assert_raises(ArgumentError) { AzureGenericResources.new(api_version: '2020-01-01') }
  end
end
