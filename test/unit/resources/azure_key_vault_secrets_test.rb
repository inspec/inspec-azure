require_relative 'helper'
require 'azure_key_vault_secrets'

class AzureKeyVaultSecretsConstructorTest < Minitest::Test
  def tag_value_not_ok
    assert_raises(ArgumentError) { AzureKeyVaultSecrets.new(tag_value: 'some_tag_value') }
  end

  def tag_name_not_ok
    assert_raises(ArgumentError) { AzureKeyVaultSecrets.new(tag_name: 'some_tag_name') }
  end

  def test_resource_id_not_ok
    assert_raises(ArgumentError) { AzureKeyVaultSecrets.new(resource_id: 'some_id') }
  end

  def test_name_not_ok
    assert_raises(ArgumentError) { AzureKeyVaultSecrets.new(name: 'some_name') }
  end
end
