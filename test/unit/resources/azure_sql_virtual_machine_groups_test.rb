require_relative 'helper'
require 'azure_sql_virtual_machine_groups'

class AzureSQLVirtualMachineGroupsConstructorTest < Minitest::Test
  # resource_type should not be allowed.
  def test_resource_type_not_ok
    assert_raises(ArgumentError) { AzureSQLVirtualMachineGroups.new(resource_provider: 'some_type') }
  end

  def tag_value_not_ok
    assert_raises(ArgumentError) { AzureSQLVirtualMachineGroups.new(tag_value: 'some_tag_value') }
  end

  def tag_name_not_ok
    assert_raises(ArgumentError) { AzureSQLVirtualMachineGroups.new(tag_name: 'some_tag_name') }
  end

  def test_name_not_ok
    assert_raises(ArgumentError) { AzureSQLVirtualMachineGroups.new(name: 'some_name') }
  end
end
