require_relative 'helper'

class AzureKeyVaultConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureKeyVault.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureKeyVault.new(resource_provider: 'some_type') }
  end

  def test_resource_group_should_exist
    assert_raises(ArgumentError) { AzureKeyVault.new(name: 'my-name') }
  end
end
