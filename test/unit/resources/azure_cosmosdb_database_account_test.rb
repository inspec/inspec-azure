require_relative "helper"
require "azure_cosmosdb_database_account"

class AzureCosmosDbDatabaseAccountConstructorTest < Minitest::Test
  def test_empty_param_not_ok
    assert_raises(ArgumentError) { AzureCosmosDbDatabaseAccount.new }
  end

  # resource_provider should not be allowed.
  def test_resource_provider_not_ok
    assert_raises(ArgumentError) { AzureCosmosDbDatabaseAccount.new(resource_provider: "some_type") }
  end

  def test_resource_group
    assert_raises(ArgumentError) { AzureCosmosDbDatabaseAccount.new(name: "my-name") }
  end
end
