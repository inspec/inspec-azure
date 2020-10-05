require_relative 'helper'
require 'azure_role_definition'

class AzureRoleDefinitionConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureRoleDefinition.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureRoleDefinition.new(resource_provider: 'some_type') }
  end

  # resource_group should not be allowed.
  def test_resource_group_not_ok
    assert_raises(ArgumentError) { AzureRoleDefinition.new(resource_group: 'some_group') }
  end
end
