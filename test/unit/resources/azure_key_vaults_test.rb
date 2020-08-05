require_relative 'helper'
require 'azure_key_vaults'

class AzureKeyVaultsConstructorTest < Minitest::Test
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureKeyVaults.new(resource_provider: 'some_type') }
  end

  def tag_value_not_ok
    assert_raises(ArgumentError) { AzureKeyVaults.new(tag_value: 'some_tag_value') }
  end

  def tag_name_not_ok
    assert_raises(ArgumentError) { AzureKeyVaults.new(tag_name: 'some_tag_name') }
  end

  def test_resource_id_not_ok
    assert_raises(ArgumentError) { AzureKeyVaults.new(resource_id: 'some_id') }
  end

  def test_name_not_ok
    assert_raises(ArgumentError) { AzureKeyVaults.new(name: 'some_name') }
  end
end
