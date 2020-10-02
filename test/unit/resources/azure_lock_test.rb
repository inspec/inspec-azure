require_relative 'helper'
require 'azure_lock'

class AzureLockConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureLock.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureLock.new(resource_provider: 'some_type') }
  end

  def test_resource_group_name_not_ok
    assert_raises(ArgumentError) { AzureLock.new(name: 'my-name', resource_group: 'test') }
  end
end
