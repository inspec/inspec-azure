require_relative 'helper'
require_relative '../../../libraries/azure_virtual_machine'

class AzureVirtualMachineConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureVirtualMachine.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureVirtualMachine.new(resource_provider: 'some_type') }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureVirtualMachine.new(name: 'my-name') }
  end
end
