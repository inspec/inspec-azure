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

  def test_resource_uri
    # add_subscription_id and resource_uri have to be provided together
    assert_raises(ArgumentError) { AzureGenericResources.new(resource_uri: 'test') }
  end
end
