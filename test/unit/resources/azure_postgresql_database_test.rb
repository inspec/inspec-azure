require_relative "helper"
require "azure_postgresql_database"

class AzurePostgreSQLDatabaseConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzurePostgreSQLDatabase.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzurePostgreSQLDatabase.new(resource_provider: "some_type") }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzurePostgreSQLDatabase.new(name: "my-name") }
  end
end
