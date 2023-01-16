require_relative "helper"
require "azure_key_vault_keys"

class AzureKeyVaultKeysConstructorTest < Minitest::Test
  def tag_value_not_ok
    assert_raises(ArgumentError) { AzureKeyVaultKeys.new(tag_value: "some_tag_value") }
  end

  def tag_name_not_ok
    assert_raises(ArgumentError) { AzureKeyVaultKeys.new(tag_name: "some_tag_name") }
  end

  def test_resource_id_not_ok
    assert_raises(ArgumentError) { AzureKeyVaultKeys.new(resource_id: "some_id") }
  end

  def test_name_not_ok
    assert_raises(ArgumentError) { AzureKeyVaultKeys.new(name: "some_name") }
  end
end
