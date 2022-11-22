require_relative 'helper'
require 'azure_snapshot'

class AzureSnapshotConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureSnapshot.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureSnapshot.new(resource_provider: 'some_type') }
  end

  def test_snapshot_name
    assert_raises(ArgumentError) { AzureSnapshot.new(resource_group: 'my_group', name: 'my-name') }
  end
end
