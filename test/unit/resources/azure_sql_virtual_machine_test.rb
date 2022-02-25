require_relative 'helper'
require 'azure_sql_virtual_machine'

class AzureSQLVirtualMachineConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureSQLVirtualMachine.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureSQLVirtualMachine.new(resource_provider: 'some_type') }
  end

  def test_resource_group_name_alone_not_ok
    assert_raises(ArgumentError) { AzureSQLVirtualMachine.new(resource_group: 'test') }
  end
end
