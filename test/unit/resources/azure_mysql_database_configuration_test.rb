require_relative 'helper'
require 'azure_mysql_database_configuration'

class AzureMySqlDatabaseConfigurationConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureMySqlDatabaseConfiguration.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureMySqlDatabaseConfiguration.new(resource_provider: 'some_type') }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureMySqlDatabaseConfiguration.new(server_name: 'my-server-name', name: 'my-name') }
  end

  def test_server_name
    assert_raises(ArgumentError) { AzureMySqlDatabaseConfiguration.new(resource_group: 'my_group', server_name: 'my-server-name', name: 'my-name') }
  end
end
