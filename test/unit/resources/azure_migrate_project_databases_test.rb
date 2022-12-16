require_relative "helper"
require "azure_migrate_project_databases"

class AzureMigrateProjectDatabasesConstructorTest < Minitest::Test
  # resource_type should not be allowed.
  def test_resource_type_not_ok
    assert_raises(ArgumentError) { AzureMigrateProjectDatabases.new(resource_provider: "some_type") }
  end

  def tag_value_not_ok
    assert_raises(ArgumentError) { AzureMigrateProjectDatabases.new(tag_value: "some_tag_value") }
  end

  def tag_name_not_ok
    assert_raises(ArgumentError) { AzureMigrateProjectDatabases.new(tag_name: "some_tag_name") }
  end

  def test_name_not_ok
    assert_raises(ArgumentError) { AzureMigrateProjectDatabases.new(name: "some_name") }
  end
end
