require_relative 'helper'

class AzureGenericResourceConstructorTest < Minitest::Test
  # Generic resource requires a parameter.
  def test_empty_params_not_ok
    assert_raises(ArgumentError) { AzureGenericResource.new }
  end

  # If resource_id is provided, there shouldn't be any other resource related parameters.
  # E.g.: resource_type, resource_group, etc.
  # They all exist in resource_id:
  # /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  def test_only_resource_id_ok
    assert_raises(ArgumentError) { AzureGenericResource.new(resource_id: 'some_id', resource_provider: 'some_type') }
  end

  def test_invalid_endpoint
    assert_raises(ArgumentError) { AzureGenericResource.new(endpoint: 'fake_endpoint') }
  end
end
