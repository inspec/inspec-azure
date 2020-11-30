require_relative 'helper'
require 'azure_key_vault_key'

class AzureKeyVaultKeyConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureKeyVaultKey.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureKeyVaultKey.new(resource_provider: 'some_type') }
  end

  def test_missing_argument
    assert_raises(ArgumentError) { AzureKeyVaultKey.new(vault_name: 'my-name') }
  end
end
