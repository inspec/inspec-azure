require_relative "helper"
require "azure_sql_database"

class AzureSqlDatabaseConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureSqlDatabase.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureSqlDatabase.new(resource_provider: "some_type") }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureSqlDatabase.new(name: "my-name") }
  end

  def test_server_name
    assert_raises(ArgumentError) { AzureSqlDatabase.new(resource_group: "my_group", name: "my-name") }
  end
end
