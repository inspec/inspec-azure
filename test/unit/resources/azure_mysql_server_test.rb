require_relative 'helper'
require_relative '../../../libraries/azure_mysql_server'

class AzureMysqlServerConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureMysqlServer.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureMysqlServer.new(resource_provider: 'some_type') }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureMysqlServer.new(name: 'my-name') }
  end
end
