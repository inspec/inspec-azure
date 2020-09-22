require_relative 'helper'
require 'azure_resource_group'

class AzureResourceGroupConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureResourceGroup.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureResourceGroup.new(resource_provider: 'some_type') }
  end
end
